part of 'posts_instagram_cubit.dart';

enum PostsInstagramStatus { initial, loading, success, failure }

extension PostsInstagramStatusX on PostsInstagramStatus {
  bool get isInitial => this == PostsInstagramStatus.initial;
  bool get isLoading => this == PostsInstagramStatus.loading;
  bool get isSuccess => this == PostsInstagramStatus.success;
  bool get isFailure => this == PostsInstagramStatus.failure;
}

class PostsInstagramState {
  final PostsInstagramStatus status;
  final List<InstagramPostEntity> posts;
  final bool hasMorePosts;
  final String? errMessage;

  PostsInstagramState({
    this.status = PostsInstagramStatus.initial,
    this.posts = const [],
    this.hasMorePosts = true,
    this.errMessage,
  });

  PostsInstagramState copyWith({
    PostsInstagramStatus? status,
    List<InstagramPostEntity>? posts,
    bool? hasMorePosts,
    String? errMessage,
  }) {
    return PostsInstagramState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasMorePosts: hasMorePosts ?? this.hasMorePosts,
      errMessage: errMessage ?? this.errMessage,
    );
  }
}
