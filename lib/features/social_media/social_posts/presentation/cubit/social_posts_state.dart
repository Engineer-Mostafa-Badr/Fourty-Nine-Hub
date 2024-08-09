part of 'social_posts_cubit.dart';

class SocialPostsState {
  final StateStatus status;
  final Failure? failure;
  final List<PostEntity>? posts;
  final List<PostEntity>? myPosts;
  final List<TwitterPostEntity>? myTweets;
  final List<SuggestUserEntity>? suggestedFriends;
  final bool? friendRequest;
  final CommentEntity? newComment;
  final int? tweetPage;
  final int? advertisementsPage;
  const SocialPostsState(
      {this.status = StateStatus.loading,
      this.friendRequest,
      this.failure,
      this.posts,
      this.myPosts,
      this.myTweets,
      this.suggestedFriends,
      this.newComment,
      this.tweetPage = 0,
      this.advertisementsPage = 0});
  SocialPostsState copyWith({
    StateStatus? status,
    Failure? failure,
    List<PostEntity>? posts,
    List<SuggestUserEntity>? suggestedFriends,
    List<PostEntity>? myPosts,
    List<TwitterPostEntity>? myTweets,
    bool? friendRequest,
    int? tweetPage,
    int? advertisementsPage,
    CommentEntity? newComment,
  }) {
    return SocialPostsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      posts: posts ?? this.posts,
      myPosts: myPosts ?? this.myPosts,
      myTweets: myTweets ?? this.myTweets,
      suggestedFriends: suggestedFriends ?? this.suggestedFriends,
      friendRequest: friendRequest ?? this.friendRequest,
      newComment: newComment ?? this.newComment,
      tweetPage: tweetPage ?? this.tweetPage,
      advertisementsPage: advertisementsPage ?? this.advertisementsPage,
    );
  }
}
