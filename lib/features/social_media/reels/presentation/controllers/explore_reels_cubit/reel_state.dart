part of 'reel_cubit.dart';

class ReelsState {

  final bool isCreatingReply;

  final List<Reel>? globalReels;
  final List<Reel>? reelsForFollower;

  final List<Reel>? reelsForAudio;
  final int? playingIndex;

  final bool? globalReelsIsLoading;
  final bool? globalReelsHasReachedMax;
  final int globalReelsCurrentPage;

  final bool reelsForFollowerIsLoading;
  final bool reelsForFollowerHasReachedMax;
  final int reelsForFollowerCurrentPage;

  final bool? isLikingComment;
  final String? likeReelCommentErrorMessage;
  final String? likeReelCommentResponseMessage;

  // Fields related to liking a reel
  final bool? isLikingReel;
  final String? likeReelErrorMessage;
  final ReelLikeResponse? likeReelResponse;

  final ReelSaveResponse? reelSaveResponse;
  final ReelShareResponse? reelShareResponse;

  // New fields related to adding a comment
  final bool isCommenting;
  final String? commentErrorMessage;
  final AddCommentResponse? commentResponse;

  // Fields related to fetching comments
  final bool isFetchingComments;
  final String? fetchCommentsErrorMessage;
  final GetCommentsResponse? fetchedComments;

  // New fields related to replaying a comment
  final bool isReplyingComment;
  final String? replyCommentErrorMessage;
  final AddCommentResponse? replyCommentResponse;

  // Fields related to uploading a reel
  final bool isUploadingReel;
  final String? uploadReelErrorMessage;
  final bool? uploadReelSuccess;

  // Fields for Reel View operation (ReelViewState)
  final bool? isCreatingReelView;
  final String? reelViewErrorMessage;
  final bool? reelViewSuccess;

  final bool isInitialized;
  final bool isPlaying;
  final bool showPlayPauseIcon;
  ReelsState({
    this.isCreatingReelView,
    this.isCreatingReply = false,
    this.reelViewErrorMessage,
    this.reelViewSuccess,
    this.reelsForFollower,
    this.isInitialized = false,
    this.isPlaying = false,
    this.showPlayPauseIcon = true,
    this.reelsForFollowerIsLoading = false,
    this.reelsForFollowerHasReachedMax = false,
    this.reelsForFollowerCurrentPage = 0,
    this.reelsForAudio,
    this.isLikingComment = false,
    this.likeReelCommentErrorMessage = '',
    this.likeReelCommentResponseMessage = '',
    this.reelSaveResponse,
    this.reelShareResponse,
    this.globalReels,
    this.globalReelsIsLoading,
    this.playingIndex,
    this.globalReelsHasReachedMax,
    this.globalReelsCurrentPage = 0,
    this.isLikingReel = false,
    this.likeReelErrorMessage,
    this.likeReelResponse,
    this.isCommenting = false,
    this.commentErrorMessage,
    this.commentResponse,
    this.isFetchingComments = false,
    this.fetchCommentsErrorMessage,
    this.fetchedComments,
    this.isReplyingComment = false,
    this.replyCommentErrorMessage,
    this.replyCommentResponse,
    this.isUploadingReel = false,
    this.uploadReelErrorMessage,
    this.uploadReelSuccess,
  });

  ReelsState copyWith({
    bool? isCreatingReply,
    bool? isCreatingReelView,
    String? reelViewErrorMessage,
    bool? reelViewSuccess,
    List<Reel>? reelsForFollower,
    bool? reelsForFollowerIsLoading,
    bool? reelsForFollowerHasReachedMax,
    int? reelsForFollowerCurrentPage,
    int? playingIndex,
    //for video controller
    bool? isInitialized,
    bool? isPlaying,
    bool? showPlayPauseIcon,
    bool? isLikingComment,
    String? likeReelCommentErrorMessage,
    String? likeReelCommentResponseMessage,
    ReelSaveResponse? reelSaveResponse,
    ReelShareResponse? reelShareResponse,
    List<Reel>? reels,
    List<Reel>? reelsForAudio,
    bool? isLoading,
    bool? hasReachedMax,
    int? currentPage,
    bool? isLikingReel,
    String? likeReelErrorMessage,
    ReelLikeResponse? likeReelResponse,
    bool? isCommenting,
    String? commentErrorMessage,
    AddCommentResponse? commentResponse,
    bool? isFetchingComments,
    String? fetchCommentsErrorMessage,
    GetCommentsResponse? fetchedComments,
    bool? isReplyingComment,
    String? replyCommentErrorMessage,
    AddCommentResponse? replyCommentResponse,
    bool? isUploadingReel,
    String? uploadReelErrorMessage,
    bool? uploadReelSuccess,
  }) {
    return ReelsState(
      isCreatingReply: isCreatingReply ?? this.isCreatingReply,
      isCreatingReelView: isCreatingReelView ?? this.isCreatingReelView,
      reelViewErrorMessage: reelViewErrorMessage ?? this.reelViewErrorMessage,
      reelViewSuccess: reelViewSuccess ?? this.reelViewSuccess,
      isLikingComment: isLikingComment ?? this.isLikingComment,
      likeReelCommentErrorMessage:
          likeReelCommentErrorMessage ?? this.likeReelCommentErrorMessage,
      likeReelCommentResponseMessage:
          likeReelCommentResponseMessage ?? this.likeReelCommentResponseMessage,
      globalReels: reels ?? globalReels,
      reelsForAudio: reelsForAudio ?? this.reelsForAudio,
      globalReelsIsLoading: isLoading ?? globalReelsIsLoading,
      globalReelsHasReachedMax: hasReachedMax ?? globalReelsHasReachedMax,
      globalReelsCurrentPage: currentPage ?? globalReelsCurrentPage,
      isLikingReel: isLikingReel ?? this.isLikingReel,
      likeReelErrorMessage: likeReelErrorMessage ?? this.likeReelErrorMessage,
      likeReelResponse: likeReelResponse ?? this.likeReelResponse,
      isCommenting: isCommenting ?? this.isCommenting,
      commentErrorMessage: commentErrorMessage ?? this.commentErrorMessage,
      commentResponse: commentResponse ?? this.commentResponse,
      isFetchingComments: isFetchingComments ?? this.isFetchingComments,
      fetchCommentsErrorMessage:
          fetchCommentsErrorMessage ?? this.fetchCommentsErrorMessage,
      fetchedComments: fetchedComments ?? this.fetchedComments,
      isReplyingComment: isReplyingComment ?? this.isReplyingComment,
      replyCommentErrorMessage:
          replyCommentErrorMessage ?? this.replyCommentErrorMessage,
      replyCommentResponse: replyCommentResponse ?? this.replyCommentResponse,
      isUploadingReel: isUploadingReel ?? this.isUploadingReel,
      uploadReelErrorMessage:
          uploadReelErrorMessage ?? this.uploadReelErrorMessage,
      uploadReelSuccess: uploadReelSuccess ?? this.uploadReelSuccess,
      reelSaveResponse: reelSaveResponse ?? this.reelSaveResponse,
      reelShareResponse: reelShareResponse ?? this.reelShareResponse,
      playingIndex: playingIndex ?? this.playingIndex,
      reelsForFollower: reelsForFollower ?? this.reelsForFollower,
      reelsForFollowerCurrentPage:
          reelsForFollowerCurrentPage ?? this.reelsForFollowerCurrentPage,
      reelsForFollowerHasReachedMax:
          reelsForFollowerHasReachedMax ?? this.reelsForFollowerHasReachedMax,
      reelsForFollowerIsLoading:
          reelsForFollowerIsLoading ?? this.reelsForFollowerIsLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      isPlaying: isPlaying ?? this.isPlaying,
      showPlayPauseIcon: showPlayPauseIcon ?? this.showPlayPauseIcon,
    );
  }
}
