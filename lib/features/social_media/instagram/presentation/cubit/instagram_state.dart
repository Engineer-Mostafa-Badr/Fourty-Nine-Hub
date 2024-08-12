part of 'instagram_cubit.dart';

class InstagramState {
  final StateStatus? status;
  final Failure? failure;
  final int? advertisementsPage;
  final int? newPage;
  final List<PostEntity>? posts;
  final int? pageIndex;
  CommentEntity? newComment;

  InstagramState(
      {this.advertisementsPage=0,this.newPage=0,this.pageIndex=0, this.posts, this.status, this.failure,this.newComment});
  InstagramState copyWith({
    StateStatus? status,
    Failure? failure,
    List<PostEntity>? posts,
    int? advertisementsPage,
    int? newPage,
    int? pageIndex,
    CommentEntity? newComment,
  }) {
    return InstagramState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      posts: posts ?? this.posts,
      advertisementsPage: advertisementsPage ?? this.advertisementsPage,
      newPage: newPage ?? this.newPage,
      pageIndex: pageIndex ?? this.pageIndex,
      newComment: newComment ?? this.newComment,
    );
  }
}

