part of 'tube_cubit.dart';
class TubeState {
  final StateStatus? status;
  final Failure? failure;
  final List<GetAllTubeVideosEntity>? getAllTubeVideosData;

  final GetAllTubeVideosEntity? currentVideo;
  /// Videos controller
  // final Video? currentVideo;
  final VideoPlayerController? videoPlayerController;
  final ChewieController? chewieController;
  final bool isMinimized;
  final bool isPlaying;
  final bool isLoading; // New flag to indicate loading state
  final bool showForwardIndicator;
  final bool showBackwardIndicator;
  ///  Videos Controller
  final bool isBackgroundMode;
  TubeState({
    this.status,
    this.failure,
    this.videoPlayerController,
    this.chewieController,
    this.isMinimized = false,
    this.isPlaying = false,
    this.isLoading = false,
    this.showForwardIndicator = false,
    this.showBackwardIndicator = false,
    this.isBackgroundMode = false, // default value
    this.getAllTubeVideosData ,
    this.currentVideo ,
  });

  TubeState copyWith({
    StateStatus? status,
    Failure? failure,
    VideoPlayerController? videoPlayerController,
    ChewieController? chewieController,
    bool? isMinimized,
    bool? isPlaying,
    bool? isLoading,
    bool? showForwardIndicator,
    bool? showBackwardIndicator,
    GetAllTubeVideosEntity? currentVideo,
    List<GetAllTubeVideosEntity>? getAllTubeVideosData,
    bool clearCurrentVideo = false,
    bool clearControllers = false,
    bool? isBackgroundMode,
  }) {
    return TubeState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      videoPlayerController: clearControllers
          ? null
          : videoPlayerController ?? this.videoPlayerController,
      chewieController: clearControllers
          ? null
          : chewieController ?? this.chewieController,
      isMinimized: isMinimized ?? this.isMinimized,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      showForwardIndicator: showForwardIndicator ?? this.showForwardIndicator,
      showBackwardIndicator: showBackwardIndicator ?? this.showBackwardIndicator,
      getAllTubeVideosData: getAllTubeVideosData ?? this.getAllTubeVideosData,
      currentVideo: clearCurrentVideo ? null : currentVideo ?? this.currentVideo,
      isBackgroundMode: isBackgroundMode ?? this.isBackgroundMode,
    );
  }

}
