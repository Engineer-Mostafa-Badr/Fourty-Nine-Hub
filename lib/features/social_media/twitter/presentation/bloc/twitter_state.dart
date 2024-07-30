part of 'twitter_bloc.dart';

class TwitterState {
  final StateStatus status;
  final StateStatus shareStatus;
  final StateStatus reactStatus;
  final Failure? failure;
  final List<TwitterPostEntity>? posts;
  final List<TwitterPostEntity>? userTweets;
  final TwitterPostEntity? postDetails;
  final List<TwitterPostEntity>? myPosts;
  final List<TwitterPostCommentEntity>? postComments;
  final List<TwitterCommentReplyEntity>? commentReplies;
  final String? newCommentId;
  final String? newReplyId;
  final UploadFileEntity? personalPhoto;
  final UploadFileEntity? frontId;
  final UploadFileEntity? backId;
  final bool? shareSuccess;
  final bool? reportSuccess;
  final bool? reported;
  final TwitterPostCommentEntity? newComment;
  final TwitterCommentReplyEntity? newReply;
  const TwitterState({
    this.shareStatus = StateStatus.loading,
    this.reactStatus = StateStatus.loading,
    this.status = StateStatus.loading,
    this.failure,
    this.posts,
    this.myPosts,
    this.postComments,
    this.commentReplies,
    this.shareSuccess = false,
    this.postDetails,
    this.newCommentId,
    this.newReplyId,
    this.newComment,
    this.newReply,
    this.reported,
    this.personalPhoto,
    this.frontId,
    this.backId,
    this.reportSuccess,
    this.userTweets,
  });
  TwitterState copyWith({
    StateStatus? shareStatus,
    StateStatus? reactStatus,
    StateStatus? status,
    Failure? failure,
    List<TwitterPostEntity>? posts,
    TwitterPostEntity? postDetails,
    List<TwitterPostEntity>? myPosts,
    List<TwitterPostCommentEntity>? postComments,
    List<TwitterCommentReplyEntity>? commentReplies,
    bool? shareSuccess,
    bool? reported,
    TwitterPostCommentEntity? newComment,
    TwitterCommentReplyEntity? newReply,
    UploadFileEntity? personalPhoto,
    UploadFileEntity? frontId,
    UploadFileEntity? backId,
    bool? reportSuccess,
    List<TwitterPostEntity>? userTweets,
  }) {
    return TwitterState(
      shareStatus: shareStatus ?? this.shareStatus,
      reported: reported ?? this.reported,
      reactStatus: reactStatus ?? this.reactStatus,
      status: status ?? this.status,
      shareSuccess: shareSuccess ?? this.shareSuccess,
      failure: failure ?? this.failure,
      posts: posts ?? this.posts,
      myPosts: myPosts ?? this.myPosts,
      postDetails: postDetails ?? this.postDetails,
      postComments: postComments ?? this.postComments,
      commentReplies: commentReplies ?? this.commentReplies,
      newComment: newComment ?? this.newComment,
      newReply: newReply ?? this.newReply,
      personalPhoto: personalPhoto ?? this.personalPhoto,
      frontId: frontId ?? this.frontId,
      backId: backId ?? this.backId,
      reportSuccess: reportSuccess ?? this.reportSuccess,
      userTweets: userTweets ?? this.userTweets,
    );
  }
}

class AddCommentState extends TwitterState {}

class ShowRepliesLoadingState extends TwitterState {}

class ShowRepliesSuccessState extends TwitterState {}
