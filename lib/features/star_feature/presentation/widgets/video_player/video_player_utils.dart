import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Enum for different video initialization strategies
enum VideoInitializationStrategy {
  standard,
  noFormatHint,
  dashFormat,
  otherFormat,
  alternativeOptions,
}

/// Video player utilities and helpers
class VideoPlayerUtils {

  /// Format duration to readable string
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return "$hours:${twoDigits(minutes)}:${twoDigits(seconds)}";
    } else {
      return "${minutes}:${twoDigits(seconds)}";
    }
  }

  /// Get device info for debugging
  static String getDeviceInfo() {
    // You can expand this to get actual device info
    return "Unknown Device";
  }

  /// Show error message with retry option
  static void showVideoError({
    required BuildContext context,
    required String message,
    VoidCallback? onRetry,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: onRetry != null
            ? SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  /// Calculate video aspect ratio
  static double calculateAspectRatio(VideoPlayerController controller) {
    if (!controller.value.isInitialized) {
      return 16 / 9; // Default aspect ratio
    }
    return controller.value.aspectRatio;
  }

  /// Get video progress as percentage
  static double getVideoProgress(VideoPlayerController controller) {
    if (!controller.value.isInitialized) return 0.0;
    final duration = controller.value.duration.inMilliseconds;
    final position = controller.value.position.inMilliseconds;
    return duration > 0 ? position / duration : 0.0;
  }

  /// Check if video is near end (last 10 seconds)
  static bool isVideoNearEnd(VideoPlayerController controller) {
    if (!controller.value.isInitialized) return false;
    final remaining = controller.value.duration - controller.value.position;
    return remaining.inSeconds <= 10;
  }

  /// Seek to specific percentage of video
  static void seekToPercentage(VideoPlayerController controller, double percentage) {
    if (!controller.value.isInitialized) return;
    final duration = controller.value.duration;
    final position = duration * percentage.clamp(0.0, 1.0);
    controller.seekTo(position);
  }

  /// Get video size for display
  static Size getVideoDisplaySize({
    required VideoPlayerController controller,
    required Size availableSize,
    BoxFit fit = BoxFit.contain,
  }) {
    if (!controller.value.isInitialized) {
      return availableSize;
    }

    final videoSize = controller.value.size;
    final aspectRatio = videoSize.width / videoSize.height;

    switch (fit) {
      case BoxFit.contain:
        if (availableSize.width / aspectRatio <= availableSize.height) {
          return Size(availableSize.width, availableSize.width / aspectRatio);
        } else {
          return Size(availableSize.height * aspectRatio, availableSize.height);
        }
      case BoxFit.cover:
        if (availableSize.width / aspectRatio >= availableSize.height) {
          return Size(availableSize.width, availableSize.width / aspectRatio);
        } else {
          return Size(availableSize.height * aspectRatio, availableSize.height);
        }
      default:
        return availableSize;
    }
  }
}

/// Video initializer with fallback strategies
class VideoInitializer {

  /// Initialize video controller with fallback strategies
  static Future<VideoPlayerController> initializeWithStrategy(
    String videoUrl,
    VideoInitializationStrategy strategy,
  ) async {
    VideoPlayerController controller;

    switch (strategy) {
      case VideoInitializationStrategy.standard:
        controller = VideoPlayerController.networkUrl(
          Uri.parse(videoUrl),
        );
        break;

      case VideoInitializationStrategy.noFormatHint:
        controller = VideoPlayerController.networkUrl(
          Uri.parse(videoUrl),
        );
        break;

      case VideoInitializationStrategy.dashFormat:
        controller = VideoPlayerController.networkUrl(
          Uri.parse(videoUrl),
          formatHint: VideoFormat.dash,
        );
        break;

      case VideoInitializationStrategy.otherFormat:
        controller = VideoPlayerController.networkUrl(
          Uri.parse(videoUrl),
          formatHint: VideoFormat.other,
        );
        break;

      case VideoInitializationStrategy.alternativeOptions:
        controller = VideoPlayerController.networkUrl(
          Uri.parse(videoUrl),
          videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: false,
            allowBackgroundPlayback: false,
          ),
        );
        break;
    }

    await controller.initialize();
    return controller;
  }

  /// Initialize video with multiple fallback strategies
  static Future<VideoPlayerController> initializeWithFallbacks(
    String videoUrl, {
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final strategies = [
      VideoInitializationStrategy.standard,
      VideoInitializationStrategy.noFormatHint,
      VideoInitializationStrategy.dashFormat,
      VideoInitializationStrategy.otherFormat,
      VideoInitializationStrategy.alternativeOptions,
    ];

    for (int i = 0; i < strategies.length; i++) {
      final strategy = strategies[i];

      try {
        final controller = await initializeWithStrategy(videoUrl, strategy)
            .timeout(timeout);
        return controller;
      } catch (error) {
        if (i == strategies.length - 1) {
          // Last strategy failed, rethrow error
          rethrow;
        }
        // Continue to next strategy
        continue;
      }
    }

    throw Exception('All video initialization strategies failed');
  }
}

/// Video player state manager
class VideoPlayerStateManager {
  static final Map<String, VideoPlayerController> _controllers = {};
  static final Map<String, StreamSubscription> _listeners = {};

  /// Get or create controller for video
  static VideoPlayerController getController(String videoId, String videoUrl) {
    if (_controllers.containsKey(videoId)) {
      return _controllers[videoId]!;
    }

    final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    _controllers[videoId] = controller;
    return controller;
  }

  /// Add listener to controller
  static void addListener(String videoId, VoidCallback listener) {
    final controller = _controllers[videoId];
    if (controller != null) {
      controller.addListener(listener);
    }
  }

  /// Remove listener from controller
  static void removeListener(String videoId, VoidCallback listener) {
    final controller = _controllers[videoId];
    if (controller != null) {
      controller.removeListener(listener);
    }
  }

  /// Dispose controller
  static void disposeController(String videoId) {
    final controller = _controllers[videoId];
    final listener = _listeners[videoId];

    if (controller != null) {
      controller.dispose();
      _controllers.remove(videoId);
    }

    if (listener != null) {
      listener.cancel();
      _listeners.remove(videoId);
    }
  }

  /// Dispose all controllers
  static void disposeAll() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    for (final listener in _listeners.values) {
      listener.cancel();
    }
    _controllers.clear();
    _listeners.clear();
  }
}

/// Video quality settings
enum VideoQuality {
  auto,
  low,
  medium,
  high,
  hd,
}

/// Video playback speed settings
enum PlaybackSpeed {
  x0_25(0.25),
  x0_5(0.5),
  x0_75(0.75),
  x1_0(1.0),
  x1_25(1.25),
  x1_5(1.5),
  x1_75(1.75),
  x2_0(2.0);

  const PlaybackSpeed(this.value);
  final double value;

  String get label {
    if (value == 1.0) return 'Normal';
    return '${value}x';
  }
}

/// Video player settings
class VideoPlayerSettings {
  final VideoQuality quality;
  final PlaybackSpeed speed;
  final bool autoplay;
  final bool loop;
  final bool muted;

  const VideoPlayerSettings({
    this.quality = VideoQuality.auto,
    this.speed = PlaybackSpeed.x1_0,
    this.autoplay = false,
    this.loop = false,
    this.muted = false,
  });

  VideoPlayerSettings copyWith({
    VideoQuality? quality,
    PlaybackSpeed? speed,
    bool? autoplay,
    bool? loop,
    bool? muted,
  }) {
    return VideoPlayerSettings(
      quality: quality ?? this.quality,
      speed: speed ?? this.speed,
      autoplay: autoplay ?? this.autoplay,
      loop: loop ?? this.loop,
      muted: muted ?? this.muted,
    );
  }
}