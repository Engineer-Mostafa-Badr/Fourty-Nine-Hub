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

  VideoPlayerManager._();

  // Configuration - Optimized for performance
  static const int maxConcurrentVideos = 3; // Limit memory usage
  static const Duration initializationTimeout = Duration(seconds: 10);
  static const Duration inactiveCleanupDuration = Duration(minutes: 3); // Auto cleanup

  // Track all active controllers
  final Map<String, VideoPlayerControllerWrapper> _controllers = {};
  final Map<String, DateTime> _lastAccessTime = {};

  /// Get or create controller with resource management
  Future<VideoPlayerControllerWrapper?> getController(
    String videoUrl,
    String videoId, {
    bool autoInitialize = true,
  }) async {
    // Return existing controller if available
    if (_controllers.containsKey(videoId)) {
      _lastAccessTime[videoId] = DateTime.now();
      return _controllers[videoId];
    }

    // Clean up excess controllers if needed
    if (_controllers.length >= maxConcurrentVideos) {
      await _cleanupOldestController();
    }

    try {
      // Create new controller
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
      );

      if (autoInitialize) {
        await controller.initialize().timeout(
          initializationTimeout,
          onTimeout: () {
            throw TimeoutException('Video initialization timeout');
          },
        );
      }

      // Wrap controller
      final wrapper = VideoPlayerControllerWrapper(
        controller: controller,
        videoId: videoId,
      );

      _controllers[videoId] = wrapper;
      _lastAccessTime[videoId] = DateTime.now();

      debugPrint('✅ Video controller created for: $videoId');
      return wrapper;
    } catch (e) {
      debugPrint('❌ Failed to create video controller for $videoId: $e');
      return null;
    }
  }

  /// Get existing controller without creating new one
  VideoPlayerControllerWrapper? getExistingController(String videoId) {
    return _controllers[videoId];
  }

  /// Clean up oldest (least recently used) controller
  Future<void> _cleanupOldestController() async {
    if (_controllers.isEmpty) return;

    // Find oldest accessed controller
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

  /// Dispose specific controller
  Future<void> disposeController(String videoId) async {
    final wrapper = _controllers[videoId];
    if (wrapper != null) {
      try {
        await wrapper.dispose();
        await wrapper.controller.dispose();
        _controllers.remove(videoId);
        _lastAccessTime.remove(videoId);
        debugPrint('🗑️ Disposed controller: $videoId');
      } catch (e) {
        debugPrint('Error disposing controller $videoId: $e');
      }
    }
  }

  /// Dispose all controllers
  Future<void> disposeAll() async {
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
      }
    }
  }

  /// Get stats for debugging
  Map<String, dynamic> getStats() {
    return {
      'activeControllers': _controllers.length,
      'maxConcurrent': maxConcurrentVideos,
      'controllers': _controllers.keys.toList(),
    };
  }

  /// Cleanup controllers that haven't been accessed recently
  Future<void> cleanupInactive({Duration inactiveDuration = const Duration(minutes: 5)}) async {
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
  }
}
