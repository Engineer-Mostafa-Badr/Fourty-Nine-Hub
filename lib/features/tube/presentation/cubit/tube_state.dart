part of 'tube_cubit.dart';

class TubeState {
  final StateStatus status;
  final List<GetAllTubeVideosEntity>? getAllTubeVideosData;
  final List<GetAllTubeVideosEntity>? getMyTubeVideosData;
  final List<GetAllTubeVideosEntity>? searchTubeVideosData;
  final List<GetAllTubeVideosEntity>? relatedTubeVideosData;
  final List<GetAllTubeVideosEntity>? historyTubeVideos;
  final GetAllTubeVideosEntity? currentVideo;
  final VideoPlayerController? videoPlayerController;
  final ChewieController? chewieController;
  final bool isPlaying;
  final bool isMinimized;
  final bool isLoading;
  final String? errorMessage;
  final bool showForwardIndicator;
  final bool showBackwardIndicator;
  final bool clearCurrentVideo;
  final bool clearControllers;
  final Failure? failure;
  final AddFavoriteTubeEntity? addFavoriteTubeData;
  final List<GetAllTubeVideosEntity>? getFavoriteTubeVideosData;
  final bool areControllersInitialized;
  final List<TubeCommentEntity>? tubeVideoCommentsData;
  final Map<String, bool> expandedComments;
  final String? lastRepliedCommentId;
  final Duration? lastPlaybackPosition;
  final List<ActiveCategoryEntity>? activeCategories;
  final List<UploadFileEntity>? videos;
  final StateStatus uploadStatus;

  /// 👇 NEW FIELD
  final bool showSnackbar;
  final bool? isWatchLater;   // <-- NEW
  TubeState({
    this.status = StateStatus.initial,
    this.getAllTubeVideosData = const [],
    this.getMyTubeVideosData,
    this.searchTubeVideosData,
    this.relatedTubeVideosData = const [],
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
    this.getFavoriteTubeVideosData,
    this.areControllersInitialized = false,
    this.tubeVideoCommentsData = const [],
    this.expandedComments = const {},
    this.lastRepliedCommentId,
    this.lastPlaybackPosition,
    this.activeCategories,
    this.videos = const [],
    this.uploadStatus = StateStatus.initial,
    this.showSnackbar = false, // 👈 default false
    this.isWatchLater,
    this.historyTubeVideos,
  });

  TubeState copyWith({
    StateStatus? status,
    List<GetAllTubeVideosEntity>? getAllTubeVideosData,
    List<GetAllTubeVideosEntity>? relatedTubeVideosData,
    List<GetAllTubeVideosEntity>? getMyTubeVideosData,
    List<GetAllTubeVideosEntity>? historyTubeVideos,
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
    bool? areControllersInitialized,
    List<TubeCommentEntity>? tubeVideoCommentsData,
    Map<String, bool>? expandedComments,
    String? lastRepliedCommentId,
    Duration? lastPlaybackPosition,
    List<ActiveCategoryEntity>? activeCategories,
    List<UploadFileEntity>? videos,
    StateStatus? uploadStatus,
    bool? showSnackbar, // 👈 added here
    bool? isWatchLater,
  }) {
    return TubeState(
      status: status ?? this.status,
      getAllTubeVideosData: getAllTubeVideosData ?? this.getAllTubeVideosData,
      getMyTubeVideosData: getMyTubeVideosData ?? this.getMyTubeVideosData,
      relatedTubeVideosData: relatedTubeVideosData ?? this.relatedTubeVideosData,
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
      getFavoriteTubeVideosData:
      getFavoriteTubeVideosData ?? this.getFavoriteTubeVideosData,
      areControllersInitialized:
      areControllersInitialized ?? this.areControllersInitialized,
      tubeVideoCommentsData:
      tubeVideoCommentsData ?? this.tubeVideoCommentsData,
      expandedComments: expandedComments ?? this.expandedComments,
      lastRepliedCommentId:
      lastRepliedCommentId ?? this.lastRepliedCommentId,
      lastPlaybackPosition:
      lastPlaybackPosition ?? this.lastPlaybackPosition,
      activeCategories: activeCategories ?? this.activeCategories,
      videos: videos ?? this.videos,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      showSnackbar: showSnackbar ?? this.showSnackbar, // ✅
      isWatchLater: isWatchLater ?? this.isWatchLater,
      historyTubeVideos: historyTubeVideos ?? this.historyTubeVideos,
    );
  }
}


