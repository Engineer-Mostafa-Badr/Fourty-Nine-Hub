import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'video_player_controller_wrapper.dart';

/// Singleton video player manager
/// Manages video player instances with resource optimization
class VideoPlayerManager {
  static VideoPlayerManager? _instance;
  static VideoPlayerManager get instance {
    _instance ??= VideoPlayerManager._();
    return _instance!;
  }

  VideoPlayerManager._() {
    _startMemoryMonitor();
  }

  // Configuration - Optimized for performance
  static const int maxConcurrentVideos = 2; // Reduced from 3 to minimize buffer pool pressure
  static const Duration initializationTimeout = Duration(seconds: 8);
  static const Duration inactiveCleanupDuration = Duration(minutes: 2); // More aggressive cleanup
  static const Duration preWarmTimeout = Duration(seconds: 5);

  // Track all active controllers
  final Map<String, VideoPlayerControllerWrapper> _controllers = {};
  final Map<String, DateTime> _lastAccessTime = {};
  final Map<String, DateTime> _lastPlayTime = {};

  // Pre-warming queue for next videos
  final Map<String, VideoPlayerController> _preWarmedControllers = {};

  // Track controller states to prevent flush/resume cycles
  final Map<String, bool> _isControllerActive = {};

  // Memory monitor timer
  Timer? _memoryMonitorTimer;

  /// Get or create controller with resource management
  Future<VideoPlayerControllerWrapper?> getController(
    String videoUrl,
    String videoId, {
    bool autoInitialize = true,
  }) async {
    // Return existing controller if available
    if (_controllers.containsKey(videoId)) {
      _lastAccessTime[videoId] = DateTime.now();
      _isControllerActive[videoId] = true;
      return _controllers[videoId];
    }

    // Check if pre-warmed controller exists
    if (_preWarmedControllers.containsKey(videoId)) {
      debugPrint('🔥 Using pre-warmed controller for: $videoId');
      final preWarmedController = _preWarmedControllers.remove(videoId);
      if (preWarmedController != null) {
        final wrapper = VideoPlayerControllerWrapper(
          controller: preWarmedController,
          videoId: videoId,
        );
        _controllers[videoId] = wrapper;
        _lastAccessTime[videoId] = DateTime.now();
        _isControllerActive[videoId] = true;
        return wrapper;
      }
    }

    // Clean up excess controllers if needed (more aggressive)
    while (_controllers.length >= maxConcurrentVideos) {
      await _cleanupOldestController();
    }

    try {
      // Create new controller with optimized settings
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true, // Allow mixing with other apps like Google Meet
          allowBackgroundPlayback: true, // Allow playback when app is in background
        ),
        httpHeaders: {
          'Connection': 'keep-alive', // Reuse HTTP connections
        },
      );

      if (autoInitialize) {
        await controller.initialize().timeout(
          initializationTimeout,
          onTimeout: () {
            throw TimeoutException('Video initialization timeout');
          },
        );

        // Pre-configure to reduce MediaCodec flush cycles
        await controller.setLooping(false);
        await controller.setVolume(0); // Start muted to avoid AudioTrack issues
      }

      // Wrap controller
      final wrapper = VideoPlayerControllerWrapper(
        controller: controller,
        videoId: videoId,
      );

      _controllers[videoId] = wrapper;
      _lastAccessTime[videoId] = DateTime.now();
      _isControllerActive[videoId] = true;

      debugPrint('✅ Video controller created for: $videoId (${_controllers.length}/$maxConcurrentVideos)');
      return wrapper;
    } catch (e) {
      debugPrint('❌ Failed to create video controller for $videoId: $e');
      return null;
    }
  }

  /// Pre-warm next video controller in background
  Future<void> preWarmController(String videoUrl, String videoId) async {
    // Don't pre-warm if already exists or being pre-warmed
    if (_controllers.containsKey(videoId) || _preWarmedControllers.containsKey(videoId)) {
      return;
    }

    // Limit pre-warmed controllers
    if (_preWarmedControllers.length >= 2) {
      final firstKey = _preWarmedControllers.keys.first;
      _preWarmedControllers.remove(firstKey)?.dispose();
    }

    try {
      debugPrint('🔥 Pre-warming controller for: $videoId');
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true, // Allow mixing with other apps
          allowBackgroundPlayback: true, // Allow background playback
        ),
        httpHeaders: {
          'Connection': 'keep-alive',
        },
      );

      await controller.initialize().timeout(
        preWarmTimeout,
        onTimeout: () {
          controller.dispose();
          throw TimeoutException('Pre-warm timeout');
        },
      );

      await controller.setLooping(false);
      await controller.setVolume(0);

      _preWarmedControllers[videoId] = controller;
      debugPrint('✅ Pre-warmed controller ready: $videoId');
    } catch (e) {
      debugPrint('⚠️ Pre-warm failed for $videoId: $e');
    }
  }

  /// Get existing controller without creating new one
  VideoPlayerControllerWrapper? getExistingController(String videoId) {
    return _controllers[videoId];
  }

  /// Clean up oldest (least recently used) controller
  Future<void> _cleanupOldestController() async {
    if (_controllers.isEmpty) return;

    // Prioritize cleanup of inactive controllers
    String? inactiveKey;
    for (final entry in _isControllerActive.entries) {
      if (!entry.value) {
        inactiveKey = entry.key;
        break;
      }
    }

    if (inactiveKey != null) {
      await disposeController(inactiveKey);
      debugPrint('🗑️ Cleaned up inactive controller: $inactiveKey');
      return;
    }

    // Otherwise, find oldest accessed controller
    String? oldestKey;
    DateTime? oldestTime;

    for (final entry in _lastAccessTime.entries) {
      if (oldestTime == null || entry.value.isBefore(oldestTime)) {
        oldestTime = entry.value;
        oldestKey = entry.key;
      }
    }

    if (oldestKey != null) {
      await disposeController(oldestKey);
      debugPrint('🗑️ Cleaned up oldest controller: $oldestKey');
    }
  }

  /// Dispose specific controller with proper cleanup
  Future<void> disposeController(String videoId) async {
    final wrapper = _controllers[videoId];
    if (wrapper != null) {
      try {
        // Mark as inactive first
        _isControllerActive[videoId] = false;

        // Pause before disposing to avoid MediaCodec flush
        if (wrapper.isInitialized && wrapper.controller.value.isPlaying) {
          await wrapper.pause();
          // Small delay to let MediaCodec settle
          await Future.delayed(const Duration(milliseconds: 50));
        }

        // Dispose wrapper and controller
        await wrapper.dispose();
        await wrapper.controller.dispose();

        // Remove from all tracking maps
        _controllers.remove(videoId);
        _lastAccessTime.remove(videoId);
        _lastPlayTime.remove(videoId);
        _isControllerActive.remove(videoId);

        debugPrint('🗑️ Disposed controller: $videoId (${_controllers.length} remaining)');
      } catch (e) {
        debugPrint('⚠️ Error disposing controller $videoId: $e');
        // Force remove even on error
        _controllers.remove(videoId);
        _lastAccessTime.remove(videoId);
        _lastPlayTime.remove(videoId);
        _isControllerActive.remove(videoId);
      }
    }
  }

  /// Dispose all controllers
  Future<void> disposeAll() async {
    _memoryMonitorTimer?.cancel();

    // Dispose pre-warmed controllers first
    for (final controller in _preWarmedControllers.values) {
      try {
        await controller.dispose();
      } catch (e) {
        debugPrint('⚠️ Error disposing pre-warmed controller: $e');
      }
    }
    _preWarmedControllers.clear();

    // Dispose active controllers
    final keys = _controllers.keys.toList();
    for (final key in keys) {
      await disposeController(key);
    }
    debugPrint('🗑️ Disposed all controllers');
  }

  /// Pause all videos except specified one
  Future<void> pauseAllExcept(String? exceptVideoId) async {
    for (final entry in _controllers.entries) {
      if (entry.key != exceptVideoId) {
        await entry.value.pause();
        _isControllerActive[entry.key] = false;
      }
    }
  }

  /// Mark controller as inactive (not playing)
  void markInactive(String videoId) {
    _isControllerActive[videoId] = false;
  }

  /// Mark controller as active (playing)
  void markActive(String videoId) {
    _isControllerActive[videoId] = true;
    _lastPlayTime[videoId] = DateTime.now();
  }

  /// Get stats for debugging
  Map<String, dynamic> getStats() {
    return {
      'activeControllers': _controllers.length,
      'maxConcurrent': maxConcurrentVideos,
      'controllers': _controllers.keys.toList(),
      'preWarmedControllers': _preWarmedControllers.length,
      'activeStates': _isControllerActive,
    };
  }

  /// Cleanup controllers that haven't been accessed recently
  Future<void> cleanupInactive({Duration inactiveDuration = const Duration(minutes: 2)}) async {
    final now = DateTime.now();
    final keysToRemove = <String>[];

    for (final entry in _lastAccessTime.entries) {
      if (now.difference(entry.value) > inactiveDuration) {
        keysToRemove.add(entry.key);
      }
    }

    for (final key in keysToRemove) {
      await disposeController(key);
    }

    if (keysToRemove.isNotEmpty) {
      debugPrint('🗑️ Cleaned up ${keysToRemove.length} inactive controllers');
    }

    // Clean up old pre-warmed controllers
    if (_preWarmedControllers.isNotEmpty) {
      final firstKey = _preWarmedControllers.keys.first;
      _preWarmedControllers.remove(firstKey)?.dispose();
    }
  }

  /// Start memory monitor to periodically clean up
  void _startMemoryMonitor() {
    _memoryMonitorTimer?.cancel();
    _memoryMonitorTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      await cleanupInactive();

      // Log stats
      final stats = getStats();
      debugPrint('📊 Video Manager Stats: ${stats['activeControllers']}/${stats['maxConcurrent']} active, ${stats['preWarmedControllers']} pre-warmed');
    });
  }
}
