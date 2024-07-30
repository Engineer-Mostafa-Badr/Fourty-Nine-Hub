part of 'social_posts_cubit.dart';

 class SocialPostsState {
  final StateStatus status;
  final Failure? failure;
  final List<PostEntity>? posts;
  final List<PostEntity>? myPosts;
  final List<TwitterPostEntity>? myTweets;
  final List<SuggestUserEntity>? suggestedFriends;
  final bool? friendRequest;
  const SocialPostsState(
      {this.status = StateStatus.loading,this.friendRequest, this.failure, this.posts, this.myPosts,this.myTweets,this.suggestedFriends});
  SocialPostsState copyWith({
     StateStatus? status,
     Failure? failure,
     List<PostEntity>? posts,
     List<SuggestUserEntity>? suggestedFriends,
      List<PostEntity>? myPosts,
      List<TwitterPostEntity>? myTweets,
      bool? friendRequest
  }) {
    return SocialPostsState(
      status: status?? this.status, 
      failure: failure?? this.failure, 
      posts: posts?? this.posts,
      myPosts: myPosts?? this.myPosts,
      myTweets: myTweets?? this.myTweets,
      suggestedFriends: suggestedFriends?? this.suggestedFriends,
      friendRequest: friendRequest?? this.friendRequest,
    );
  }
}
