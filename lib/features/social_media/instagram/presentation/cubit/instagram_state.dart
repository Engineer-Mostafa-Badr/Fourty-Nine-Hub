part of 'instagram_cubit.dart';

class InstagramState {
  final StateStatus? status;
  final Failure? failure;
  final int? advertisementsPage;
  final List<PostEntity>? posts;
  final int? pageIndex;
  CommentEntity? newComment;

  InstagramState(
      {this.advertisementsPage=0,this.pageIndex=0, this.posts, this.status, this.failure,this.newComment});
  InstagramState copyWith({
    StateStatus? status,
    Failure? failure,
    List<PostEntity>? posts,
    int? advertisementsPage,
    int? pageIndex,
    CommentEntity? newComment,
  }) {
    return InstagramState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      posts: posts ?? this.posts,
      advertisementsPage: advertisementsPage ?? this.advertisementsPage,
      pageIndex: pageIndex ?? this.pageIndex,
      newComment: newComment ?? this.newComment,
    );
  }
}

