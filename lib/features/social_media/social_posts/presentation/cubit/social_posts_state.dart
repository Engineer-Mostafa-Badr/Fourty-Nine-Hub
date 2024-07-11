part of 'social_posts_cubit.dart';

 class SocialPostsState {
  final StateStatus status;
  final Failure? failure;
  final List<PostEntity>? posts;
  const SocialPostsState(
      {this.status = StateStatus.loading, this.failure, this.posts});
  SocialPostsState copyWith({
     StateStatus? status,
     Failure? failure,
     List<PostEntity>? posts,
  }) {
    return SocialPostsState(
      status: status?? this.status, 
      failure: failure?? this.failure, 
      posts: posts?? this.posts,
    );
  }
}
