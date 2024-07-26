part of 'twitter_bloc.dart';

class TwitterState {
  final StateStatus status;
  final StateStatus shareStatus;
  final StateStatus reactStatus;
  final Failure? failure;
  final List<TwitterPostEntity>? posts;
  final TwitterPostEntity? postDetails;
  final List<TwitterPostEntity>? myPosts;
  final List<TwitterPostCommentEntity>? postComments;
  final List<TwitterCommentReplyEntity>? commentReplies;
  final bool? shareSuccess;
  const TwitterState(
      {this.shareStatus= StateStatus.loading,this.reactStatus= StateStatus.loading, this.status = StateStatus.loading, this.failure, this.posts, this.myPosts,this.postComments,this.commentReplies,this.shareSuccess=false,this.postDetails});
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
    bool? shareSuccess
  }) {
    return TwitterState(
      shareStatus: shareStatus?? this.shareStatus,
      reactStatus: reactStatus?? this.reactStatus,
      status: status?? this.status,
      shareSuccess: shareSuccess?? this.shareSuccess,
      failure: failure?? this.failure,
      posts: posts?? this.posts,
      myPosts: myPosts?? this.myPosts,
      postDetails: postDetails?? this.postDetails,
      postComments: postComments?? this.postComments,
      commentReplies: commentReplies?? this.commentReplies,
    );
  }
}

class AddCommentState extends TwitterState {}
class ShowRepliesLoadingState extends TwitterState {}
class ShowRepliesSuccessState extends TwitterState {}

