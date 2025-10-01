/// Video player state model
/// Represents the current state of a video player instance
class VideoPlayerState {
  final bool isInitialized;
  final bool isPlaying;
  final bool isMuted;
  final bool isBuffering;
  final bool hasError;
  final String? errorMessage;
  final Duration position;
  final Duration duration;
  final double visibilityFraction;

  const VideoPlayerState({
    this.isInitialized = false,
    this.isPlaying = false,
    this.isMuted = true,
    this.isBuffering = false,
    this.hasError = false,
    this.errorMessage,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.visibilityFraction = 0.0,
  });

  VideoPlayerState copyWith({
    bool? isInitialized,
    bool? isPlaying,
    bool? isMuted,
    bool? isBuffering,
    bool? hasError,
    String? errorMessage,
    Duration? position,
    Duration? duration,
    double? visibilityFraction,
  }) {
    return VideoPlayerState(
      isInitialized: isInitialized ?? this.isInitialized,
      isPlaying: isPlaying ?? this.isPlaying,
      isMuted: isMuted ?? this.isMuted,
      isBuffering: isBuffering ?? this.isBuffering,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      visibilityFraction: visibilityFraction ?? this.visibilityFraction,
    );
  }

  bool get canPlay => isInitialized && !hasError;
  bool get isAtEnd => position >= duration && duration.inMilliseconds > 0;
  double get progress => duration.inMilliseconds > 0
      ? position.inMilliseconds / duration.inMilliseconds
      : 0.0;
}
