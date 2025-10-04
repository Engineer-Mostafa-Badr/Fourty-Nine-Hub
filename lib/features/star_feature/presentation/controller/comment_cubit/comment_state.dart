part of 'comment_cubit.dart';

class CommentState {
  final List<CommentModel> comments;
  final bool isLoading;
  final bool isCreatingComment;
  final bool hasMore;
  final int currentPage;
  final int totalComments;
  final String? error;

  CommentState({
    this.comments = const [],
    this.isLoading = false,
    this.isCreatingComment = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.totalComments = 0,
    this.error,
  });

  CommentState copyWith({
    List<CommentModel>? comments,
    bool? isLoading,
    bool? isCreatingComment,
    bool? hasMore,
    int? currentPage,
    int? totalComments,
    String? error,
  }) {
    return CommentState(
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      isCreatingComment: isCreatingComment ?? this.isCreatingComment,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      totalComments: totalComments ?? this.totalComments,
      error: error,
    );
  }
}
