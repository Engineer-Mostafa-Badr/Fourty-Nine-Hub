part of 'twitter_bloc.dart';

class TwitterState {
  final StateStatus status;
  final StateStatus shareStatus;
  final StateStatus reactStatus;
  final Failure? failure;

  /// Profile bits
  final StateStatus profileStatus;                 // NEW
  final TwitterProfileEntity? profile;             // NEW
  final int? followersCount;                       // NEW
  final int? followingCount;                       // NEW

  /// Lists/objects for various screens
  final List<TwitterPostEntity> posts;
  final List<TwitterPostEntity> myPosts;
  final List<TwitterPostEntity> userTweets;

  /// Details screen (main post)
  final TwitterPostEntity? postDetails;

  /// Thread details
  final List<TwitterPostEntity> threadPosts;
  final List<TwitterPostCommentEntity> threadReplies;

  /// Comments API (paged / sheet)
  final List<TwitterPostCommentEntity> postComments;
  final List<TwitterCommentReplyEntity> commentReplies;

  /// Misc UI helpers
  final String? newCommentId;
  final String? newReplyId;
  final bool shareSuccess;
  final bool? reportSuccess;
  final bool? reported;

  /// Temp uploads
  final UploadFileEntity? personalPhoto;
  final UploadFileEntity? frontId;
  final UploadFileEntity? backId;

  /// Last created entities
  final TwitterPostCommentEntity? newComment;
  final TwitterCommentReplyEntity? newReply;

  final StateStatus repostStatus;
  final bool repostSuccess;


  const TwitterState({
    this.status = StateStatus.loading,
    this.shareStatus = StateStatus.loading,
    this.reactStatus = StateStatus.loading,
    this.failure,

    /// Profile defaults
    this.profileStatus = StateStatus.loading,
    this.profile,
    this.followersCount,
    this.followingCount,

    this.posts = const [],
    this.myPosts = const [],
    this.userTweets = const [],

    this.postDetails,
    this.threadPosts = const [],
    this.threadReplies = const [],

    this.postComments = const [],
    this.commentReplies = const [],

    this.newCommentId,
    this.newReplyId,
    this.shareSuccess = false,
    this.reported,
    this.newComment,
    this.newReply,

    this.personalPhoto,
    this.frontId,
    this.backId,
    this.reportSuccess,

    this.repostStatus = StateStatus.loading,
    this.repostSuccess = false,
  });

  TwitterState copyWith({
    StateStatus? status,
    StateStatus? shareStatus,
    StateStatus? reactStatus,
    Failure? failure,

    /// Profile
    StateStatus? profileStatus,
    TwitterProfileEntity? profile,
    int? followersCount,
    int? followingCount,

    List<TwitterPostEntity>? posts,
    List<TwitterPostEntity>? myPosts,
    List<TwitterPostEntity>? userTweets,

    TwitterPostEntity? postDetails,
    List<TwitterPostEntity>? threadPosts,
    List<TwitterPostCommentEntity>? threadReplies,

    List<TwitterPostCommentEntity>? postComments,
    List<TwitterCommentReplyEntity>? commentReplies,

    String? newCommentId,
    String? newReplyId,

    bool? shareSuccess,
    bool? reported,

    TwitterPostCommentEntity? newComment,
    TwitterCommentReplyEntity? newReply,

    UploadFileEntity? personalPhoto,
    UploadFileEntity? frontId,
    UploadFileEntity? backId,
    bool? reportSuccess,

    StateStatus? repostStatus,
    bool? repostSuccess,
  }) {
    return TwitterState(
      status: status ?? this.status,
      shareStatus: shareStatus ?? this.shareStatus,
      reactStatus: reactStatus ?? this.reactStatus,
      failure: failure ?? this.failure,

      /// Profile
      profileStatus: profileStatus ?? this.profileStatus,
      profile: profile ?? this.profile,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,

      posts: posts ?? this.posts,
      myPosts: myPosts ?? this.myPosts,
      userTweets: userTweets ?? this.userTweets,

      postDetails: postDetails ?? this.postDetails,
      threadPosts: threadPosts ?? this.threadPosts,
      threadReplies: threadReplies ?? this.threadReplies,

      postComments: postComments ?? this.postComments,
      commentReplies: commentReplies ?? this.commentReplies,

      newCommentId: newCommentId ?? this.newCommentId,
      newReplyId: newReplyId ?? this.newReplyId,
      shareSuccess: shareSuccess ?? this.shareSuccess,
      reported: reported ?? this.reported,

      newComment: newComment ?? this.newComment,
      newReply: newReply ?? this.newReply,

      personalPhoto: personalPhoto ?? this.personalPhoto,
      frontId: frontId ?? this.frontId,
      backId: backId ?? this.backId,
      reportSuccess: reportSuccess ?? this.reportSuccess,

      repostStatus: repostStatus ?? this.repostStatus,
      repostSuccess: repostSuccess ?? this.repostSuccess,

    );
  }
}

class AddCommentState extends TwitterState {}
class ShowRepliesLoadingState extends TwitterState {}
class ShowRepliesSuccessState extends TwitterState {}
