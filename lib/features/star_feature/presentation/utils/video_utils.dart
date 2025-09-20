import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

class VideoUtils {
  // Check if device supports specific video format
  static Future<bool> checkVideoFormatSupport(String videoUrl, VideoFormat format) async {
    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        formatHint: format,
      );

      await controller.initialize().timeout(Duration(seconds: 5));
      await controller.dispose();
      return true;
    } catch (e) {
      debugPrint('Video format $format not supported: $e');
      return false;
    }
  }

  // Get supported video formats for a URL by testing
  static Future<List<VideoFormat>> getSupportedFormats(String videoUrl) async {
    final supportedFormats = <VideoFormat>[];

    final formatsToTest = [
      VideoFormat.hls,
      VideoFormat.dash,
      VideoFormat.other,
    ];

    for (final format in formatsToTest) {
      if (await checkVideoFormatSupport(videoUrl, format)) {
        supportedFormats.add(format);
      }
    }

    return supportedFormats;
  }

  // Get device information for video debugging
  static Map<String, dynamic> getDeviceInfo() {
    return {
      'platform': Platform.operatingSystem,
      'version': Platform.operatingSystemVersion,
      'isAndroid': Platform.isAndroid,
      'isIOS': Platform.isIOS,
    };
  }

  // Check if codec error is platform-specific
  static bool isCodecError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('mediacodec') ||
           errorString.contains('exoplaybackexception') ||
           errorString.contains('codec') ||
           errorString.contains('decoder') ||
           errorString.contains('format');
  }

  // Get recommended video player options for the current platform
  static VideoPlayerOptions getRecommendedOptions() {
    if (Platform.isAndroid) {
      return VideoPlayerOptions(
        mixWithOthers: true,
        allowBackgroundPlayback: false,
      );
    } else if (Platform.isIOS) {
      return VideoPlayerOptions(
        mixWithOthers: false,
        allowBackgroundPlayback: true,
      );
    }

    return VideoPlayerOptions(
      mixWithOthers: true,
      allowBackgroundPlayback: false,
    );
  }

  // Get fallback strategy based on error type
  static List<VideoInitializationStrategy> getFallbackStrategies(dynamic error) {
    final strategies = <VideoInitializationStrategy>[];

    if (isCodecError(error)) {
      // Codec-specific fallbacks
      strategies.addAll([
        VideoInitializationStrategy.noFormatHint,
        VideoInitializationStrategy.dashFormat,
        VideoInitializationStrategy.otherFormat,
        VideoInitializationStrategy.alternativeOptions,
      ]);
    } else {
      // General fallbacks
      strategies.addAll([
        VideoInitializationStrategy.alternativeOptions,
        VideoInitializationStrategy.noFormatHint,
      ]);
    }

    return strategies;
  }

  // Format view count for display
  static String formatViewCount(int views) {
    if (views < 1000) {
      return views.toString();
    } else if (views < 1000000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    }
  }

  // Format duration for display
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
    } else {
      return '$twoDigitMinutes:$twoDigitSeconds';
    }
  }
}

enum VideoInitializationStrategy {
  standard,
  hlsFormat,
  dashFormat,
  otherFormat,
  noFormatHint,
  alternativeOptions,
  iosOptions,
  androidOptions,
}

class VideoInitializer {
  static Future<VideoPlayerController> initializeWithStrategy(
    String videoUrl,
    VideoInitializationStrategy strategy,
  ) async {
    late VideoPlayerController controller;

    switch (strategy) {
      case VideoInitializationStrategy.standard:
        controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
        break;

      case VideoInitializationStrategy.hlsFormat:
        controller = VideoPlayerController.networkUrl(
          Uri.parse(videoUrl),
          formatHint: VideoFormat.hls,
        );
        break;

      case VideoInitializationStrategy.dashFormat:
        controller = VideoPlayerController.networkUrl(
          Uri.parse(videoUrl),
          formatHint: VideoFormat.dash,
          videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: false,
            allowBackgroundPlayback: true,
          ),
        );
        break;

      case VideoInitializationStrategy.otherFormat:
        controller = VideoPlayerController.networkUrl(
          Uri.parse(videoUrl),
          formatHint: VideoFormat.other,
        );
        break;

      case VideoInitializationStrategy.noFormatHint:
        controller = VideoPlayerController.networkUrl(
          Uri.parse(videoUrl),
          videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: true,
            allowBackgroundPlayback: false,
          ),
        );
        break;

      case VideoInitializationStrategy.alternativeOptions:
        controller = VideoPlayerController.networkUrl(
          Uri.parse(videoUrl),
          videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: false,
            allowBackgroundPlayback: true,
          ),
        );
        break;

      case VideoInitializationStrategy.iosOptions:
        controller = VideoPlayerController.networkUrl(
          Uri.parse(videoUrl),
          videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: false,
            allowBackgroundPlayback: true,
          ),
        );
        break;

      case VideoInitializationStrategy.androidOptions:
        controller = VideoPlayerController.networkUrl(
          Uri.parse(videoUrl),
          videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: true,
            allowBackgroundPlayback: false,
          ),
        );
        break;
    }

    await controller.initialize().timeout(
      Duration(seconds: 10),
      onTimeout: () {
        throw TimeoutException('Video initialization timeout for strategy $strategy');
      },
    );

    return controller;
  }
}