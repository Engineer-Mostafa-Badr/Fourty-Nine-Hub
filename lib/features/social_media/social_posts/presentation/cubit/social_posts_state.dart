part of 'social_posts_cubit.dart';

class SocialPostsState {
  final StateStatus status;
  final Failure? failure;
  final List<PostEntity>? posts;
  final PostEntity? postDetails;
  final List<PostEntity>? myPosts;
  final List<TwitterPostEntity>? myTweets;
  final List<SuggestUserEntity>? suggestedFriends;
  final bool? friendRequest;
  final CommentEntity? newComment;
  final List<CommentEntity>? postComments;
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
      this.postComments,
      this.postDetails,
      this.tweetPage = 0,
      this.advertisementsPage = 0});
  SocialPostsState copyWith({
    StateStatus? status,
    Failure? failure,
    List<PostEntity>? posts,
    List<SuggestUserEntity>? suggestedFriends,
    List<PostEntity>? myPosts,
    List<CommentEntity>? postComments,
    List<TwitterPostEntity>? myTweets,
    bool? friendRequest,
    int? tweetPage,
    int? advertisementsPage,
    CommentEntity? newComment,
    PostEntity? postDetails,
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
      postComments: postComments ?? this.postComments,
      postDetails: postDetails ?? this.postDetails,
    );
  }
}
