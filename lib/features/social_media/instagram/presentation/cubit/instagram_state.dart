part of 'instagram_cubit.dart';

class InstagramState {
  final StateStatus? status;
  final Failure? failure;
  final int? advertisementsPage;
  final int? newPage;
  final List<PostEntity>? posts;
  final List<PostEntity>? media;
  final List<PostEntity>? reels;
  final int? pageIndex;
  final int? count;
  final List<SuggestUserEntity>? suggestedFriends;
  CommentEntity? newComment;
  final List<CommentEntity>? postComments;
  final List<FollowersEntity>? followers;
  final List<FollowingEntity>? following;

  InstagramState({
    this.advertisementsPage = 0,
    this.newPage = 0,
    this.pageIndex = 0,
    this.posts,
    this.status,
    this.failure,
    this.newComment,
    this.postComments,
    this.suggestedFriends,
    this.reels,
    this.followers,
    this.following,
    this.media,
    this.count = 0,
  });
  InstagramState copyWith({
    StateStatus? status,
    Failure? failure,
    List<PostEntity>? posts,
    List<PostEntity>? reels,
    List<PostEntity>? media,
    int? advertisementsPage,
    int? newPage,
    int? pageIndex,
    int? count,
    List<SuggestUserEntity>? suggestedFriends,
    CommentEntity? newComment,
    List<CommentEntity>? postComments,
    List<FollowersEntity>? followers,
    List<FollowingEntity>? following,
  }) {
    return InstagramState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      posts: posts ?? this.posts,
      advertisementsPage: advertisementsPage ?? this.advertisementsPage,
      newPage: newPage ?? this.newPage,
      count: count ?? this.count,
      pageIndex: pageIndex ?? this.pageIndex,
      newComment: newComment ?? this.newComment,
      postComments: postComments ?? this.postComments,
      media: media ?? this.media,
      suggestedFriends: suggestedFriends ?? this.suggestedFriends,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      reels: reels ?? this.reels,
    );
  }
}
