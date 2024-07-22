part of 'twitter_bloc.dart';

class TwitterState {
  final StateStatus status;
  final Failure? failure;
  final List<TwitterPostEntity>? posts;
  final List<TwitterPostEntity>? myPosts;
  final List<TwitterPostCommentEntity>? postComments;
  const TwitterState(
      {this.status = StateStatus.loading, this.failure, this.posts, this.myPosts,this.postComments});
  TwitterState copyWith({
    StateStatus? status,
    Failure? failure,
    List<TwitterPostEntity>? posts,
    List<TwitterPostEntity>? myPosts,
    List<TwitterPostCommentEntity>? postComments
  }) {
    return TwitterState(
      status: status?? this.status,
      failure: failure?? this.failure,
      posts: posts?? this.posts,
      myPosts: myPosts?? this.myPosts,
      postComments: postComments?? this.postComments,
    );
  }
}
