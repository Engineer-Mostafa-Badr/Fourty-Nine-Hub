part of 'tube_cubit.dart';


class TubeState {
  final StateStatus status;
  final List<GetAllTubeVideosEntity>? getAllTubeVideosData;
  final List<GetAllTubeVideosEntity>? searchTubeVideosData;
  final GetAllTubeVideosEntity? currentVideo;
  final VideoPlayerController? videoPlayerController;
  final ChewieController? chewieController;
  final bool isPlaying;
  final bool isMinimized;
  final bool isLoading;
  final String? errorMessage; // New field
  final bool showForwardIndicator;
  final bool showBackwardIndicator;
  final bool clearCurrentVideo;
  final bool clearControllers;
  final Failure? failure;
  final AddFavoriteTubeEntity? addFavoriteTubeData;
  final List<GetAllTubeVideosEntity>? getFavoriteTubeVideosData;
  TubeState({
    this.status = StateStatus.initial,
    this.getAllTubeVideosData = const [],
    this.currentVideo,
    this.videoPlayerController,
    this.chewieController,
    this.isPlaying = false,
    this.isMinimized = false,
    this.isLoading = false,
    this.errorMessage,
    this.showForwardIndicator = false,
    this.showBackwardIndicator = false,
    this.clearCurrentVideo = false,
    this.clearControllers = false,
    this.failure,
    this.addFavoriteTubeData,
    this.searchTubeVideosData,
    this.getFavoriteTubeVideosData,
  });

  TubeState copyWith({
    StateStatus? status,
    List<GetAllTubeVideosEntity>? getAllTubeVideosData,
    GetAllTubeVideosEntity? currentVideo,
    VideoPlayerController? videoPlayerController,
    ChewieController? chewieController,
    bool? isPlaying,
    bool? isMinimized,
    bool? isLoading,
    String? errorMessage,
    bool? showForwardIndicator,
    bool? showBackwardIndicator,
    bool? clearCurrentVideo,
    bool? clearControllers,
    Failure? failure,
    AddFavoriteTubeEntity? addFavoriteTubeData,
    List<GetAllTubeVideosEntity>? searchTubeVideosData,
    List<GetAllTubeVideosEntity>? getFavoriteTubeVideosData,
  }) {
    return TubeState(
      status: status ?? this.status,
      getAllTubeVideosData: getAllTubeVideosData ?? this.getAllTubeVideosData,
      currentVideo: currentVideo ?? this.currentVideo,
      videoPlayerController: videoPlayerController ?? this.videoPlayerController,
      chewieController: chewieController ?? this.chewieController,
      isPlaying: isPlaying ?? this.isPlaying,
      isMinimized: isMinimized ?? this.isMinimized,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      showForwardIndicator: showForwardIndicator ?? this.showForwardIndicator,
      showBackwardIndicator: showBackwardIndicator ?? this.showBackwardIndicator,
      clearCurrentVideo: clearCurrentVideo ?? this.clearCurrentVideo,
      clearControllers: clearControllers ?? this.clearControllers,
      failure: failure ?? this.failure,
      addFavoriteTubeData: addFavoriteTubeData ?? this.addFavoriteTubeData,
      searchTubeVideosData: searchTubeVideosData ?? this.searchTubeVideosData,
      getFavoriteTubeVideosData: getFavoriteTubeVideosData ?? this.getFavoriteTubeVideosData,
    );
  }
}
