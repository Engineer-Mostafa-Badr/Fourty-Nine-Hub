import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../domain/entity/star_entity.dart';

/// Mixin for handling video player initialization and control
mixin VideoPlayerMixin<T extends StatefulWidget> on State<T> {
  VideoPlayerController? videoController;
  bool isVideoInitialized = false;
  bool isPlaying = false;
  bool showControls = false;
  bool isFullscreen = false;
  Timer? hideControlsTimer;
  bool isDragging = false;

  /// Get video URL - override this in your widget
  String get videoUrl;

  /// Get talent entity - override this in your widget
  StarEntity get talent;

  /// Callback when duration is loaded - override if needed
  void onDurationLoaded(Duration duration) {}

  /// Initialize video player
  Future<void> initializeVideoPlayer() async {
    debugPrint('🎥 VideoPlayerMixin: Initializing video: $videoUrl');

    // If video is not approved, create a basic controller to avoid null issues
    if (!talent.isApproved) {
      videoController = VideoPlayerController.networkUrl(
        Uri.parse('about:blank'),
      );
      debugPrint('⚠️ VideoPlayerMixin: Video not approved, skipping initialization');
      return;
    }

    try {
      // Standard initialization with timeout
      videoController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        formatHint: VideoFormat.hls,
      );

      await videoController!.initialize().timeout(
        Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Video initialization timeout', Duration(seconds: 15));
        },
      );

      if (mounted) {
        debugPrint('✅ VideoPlayerMixin: Video initialized successfully');
        setState(() {
          isVideoInitialized = true;
        });
        onDurationLoaded(videoController!.value.duration);
        videoController!.play();
        setState(() => isPlaying = true);
      }
    } catch (error) {
      debugPrint('❌ VideoPlayerMixin: Video initialization error: $error');

      if (error.toString().contains('MediaCodec') ||
          error.toString().contains('ExoPlaybackException') ||
          error.toString().contains('codec')) {
        debugPrint('🔧 VideoPlayerMixin: Detected codec error, trying fallback...');
        await handleCodecError();
      } else {
        if (mounted) {
          retryVideoInitialization();
        }
      }
    }
  }

  /// Handle codec error with fallback strategies
  Future<void> handleCodecError() async {
    try {
      await videoController?.dispose();

      // Try with different format hint
      videoController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        formatHint: VideoFormat.other,
      );

      await videoController!.initialize().timeout(
        Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Fallback initialization timeout', Duration(seconds: 15));
        },
      );

      if (mounted) {
        debugPrint('✅ VideoPlayerMixin: Fallback initialization successful');
        setState(() {
          isVideoInitialized = true;
        });
        onDurationLoaded(videoController!.value.duration);
        videoController!.play();
        setState(() => isPlaying = true);
      }
    } catch (e) {
      debugPrint('❌ VideoPlayerMixin: Fallback also failed: $e');
      if (mounted) {
        retryVideoInitialization();
      }
    }
  }

  /// Retry video initialization after delay
  void retryVideoInitialization() {
    debugPrint('🔄 VideoPlayerMixin: Retrying video initialization...');
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        initializeVideoPlayer();
      }
    });
  }

  /// Toggle play/pause
  void togglePlayPause() {
    if (videoController == null || !isVideoInitialized) return;

    setState(() {
      if (isPlaying) {
        videoController!.pause();
        isPlaying = false;
      } else {
        videoController!.play();
        isPlaying = true;
        startHideControlsTimer();
      }
    });
  }

  /// Toggle fullscreen mode
  void toggleFullscreen() {
    setState(() {
      isFullscreen = !isFullscreen;
    });
  }

  /// Show controls with auto-hide timer
  void showControlsWithTimer() {
    setState(() {
      showControls = true;
    });
    startHideControlsTimer();
  }

  /// Start timer to hide controls
  void startHideControlsTimer() {
    hideControlsTimer?.cancel();
    hideControlsTimer = Timer(Duration(seconds: 3), () {
      if (mounted && isPlaying && !isDragging) {
        setState(() {
          showControls = false;
        });
      }
    });
  }

  /// Seek to position
  void seekTo(Duration position) {
    videoController?.seekTo(position);
  }

  /// Dispose video player
  void disposeVideoPlayer() {
    hideControlsTimer?.cancel();
    videoController?.dispose();
  }

  /// Format duration to string
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }
}
