import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import '../../../../../routes/pages.dart';
import '../../../data/model/comment_model.dart';
import '../../../domain/use_case/comment_use_cases.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final CreateCommentUseCase _createCommentUseCase;
  final GetCommentsUseCase _getCommentsUseCase;
  final UpdateCommentUseCase _updateCommentUseCase;
  final DeleteCommentUseCase _deleteCommentUseCase;
  final LikeCommentUseCase _likeCommentUseCase;
  final DislikeCommentUseCase _dislikeCommentUseCase;

  CommentCubit(
    this._createCommentUseCase,
    this._getCommentsUseCase,
    this._updateCommentUseCase,
    this._deleteCommentUseCase,
    this._likeCommentUseCase,
    this._dislikeCommentUseCase,
  ) : super(CommentState());

  // Get comments for a video
  Future<void> getVideoComments(String videoId, {bool refresh = false}) async {
    print('💬 CommentCubit: Getting comments for video $videoId, refresh: $refresh');

    if (refresh) {
      _resetPagination();
    }

    if (state.isLoading || (!state.hasMore && !refresh)) {
      print('💬 CommentCubit: Skipping - isLoading: ${state.isLoading}, hasMore: ${state.hasMore}');
      return;
    }

    emit(state.copyWith(isLoading: true));
    print('💬 CommentCubit: Loading comments - page: ${state.currentPage}');

    final response = await _getCommentsUseCase(GetCommentsParams(
      videoId: videoId,
      page: state.currentPage,
      limit: 20,
    ));

    response.fold(
      (failure) {
        print('❌ CommentCubit: Failed to load comments - $failure');
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));

        emit(state.copyWith(
          isLoading: false,
          error: failure.toString(),
        ));
      },
      (commentsResponse) {
        print('✅ CommentCubit: Loaded ${commentsResponse.comments.length} comments');
        print('✅ CommentCubit: Total comments: ${commentsResponse.pagination.total}');

        final newComments = refresh
            ? commentsResponse.comments
            : [...state.comments, ...commentsResponse.comments];

        emit(state.copyWith(
          isLoading: false,
          comments: newComments,
          currentPage: state.currentPage + 1,
          hasMore: commentsResponse.pagination.page <
              commentsResponse.pagination.pages,
          totalComments: commentsResponse.pagination.total,
          error: null,
        ));

        print('💬 CommentCubit: State updated - total comments in state: ${newComments.length}');
      },
    );
  }

  // Create a new comment
  Future<void> createComment({
    required String videoId,
    required String content,
    String? parentCommentId,
  }) async {
    emit(state.copyWith(isCreatingComment: true));

    final response = await _createCommentUseCase(CreateCommentParams(
      content: content,
      videoId: videoId,
      parentCommentId: parentCommentId,
    ));

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
          isCreatingComment: false,
          error: failure.toString(),
        ));
      },
      (success) {
        emit(state.copyWith(
          isCreatingComment: false,
          error: null,
        ));
        // Refresh comments to show the new one
        getVideoComments(videoId, refresh: true);
      },
    );
  }

  // Reply to a comment
  Future<void> replyToComment({
    required String videoId,
    required String parentCommentId,
    required String content,
  }) async {
    emit(state.copyWith(isCreatingComment: true));

    final response = await _createCommentUseCase(CreateCommentParams(
      content: content,
      videoId: videoId,
      parentCommentId: parentCommentId,
    ));

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
          isCreatingComment: false,
          error: failure.toString(),
        ));
      },
      (success) {
        emit(state.copyWith(
          isCreatingComment: false,
          error: null,
        ));
        // Refresh comments to show the new reply
        getVideoComments(videoId, refresh: true);
      },
    );
  }

  // Like a comment
  Future<void> likeComment(String commentId) async {
    // Optimistic update
    _updateCommentLocally(
        commentId,
        (comment) => comment.copyWith(
              likes: comment.likes + 1,
              isLiked: true,
              isDisliked: false,
            ));

    final response = await _likeCommentUseCase(commentId);

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        // Revert optimistic update
        _updateCommentLocally(
            commentId,
            (comment) => comment.copyWith(
                  likes: comment.likes - 1,
                  isLiked: false,
                ));
        emit(state.copyWith(error: failure.toString()));
      },
      (success) {
        // Success handled by optimistic update
      },
    );
  }

  // Dislike a comment
  Future<void> dislikeComment(String commentId) async {
    // Optimistic update
    _updateCommentLocally(
        commentId,
        (comment) => comment.copyWith(
              dislikes: comment.dislikes + 1,
              isDisliked: true,
              isLiked: false,
            ));

    final response = await _dislikeCommentUseCase(commentId);

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        // Revert optimistic update
        _updateCommentLocally(
            commentId,
            (comment) => comment.copyWith(
                  dislikes: comment.dislikes - 1,
                  isDisliked: false,
                ));
        emit(state.copyWith(error: failure.toString()));
      },
      (success) {
        // Success handled by optimistic update
      },
    );
  }

  // Delete a comment
  Future<void> deleteComment(String commentId, String videoId) async {
    emit(state.copyWith(isDeletingComment: true));

    final response = await _deleteCommentUseCase(commentId);

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
          isDeletingComment: false,
          error: failure.toString(),
        ));
      },
      (success) {
        emit(state.copyWith(isDeletingComment: false));
        // Refresh comments to get updated data from server
        getVideoComments(videoId, refresh: true);
      },
    );
  }

  // Update a comment
  Future<void> updateComment(String commentId, String newContent, String videoId) async {
    emit(state.copyWith(isUpdatingComment: true));

    final response = await _updateCommentUseCase(UpdateCommentParams(
      commentId: commentId,
      content: newContent,
    ));

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
          isUpdatingComment: false,
          error: failure.toString(),
        ));
      },
      (success) {
        emit(state.copyWith(isUpdatingComment: false));
        // Refresh comments to get updated data from server
        getVideoComments(videoId, refresh: true);
      },
    );
  }

  // Helper method to update a comment locally
  void _updateCommentLocally(
      String commentId, CommentModel Function(CommentModel) updater) {
    final updatedComments = state.comments.map((comment) {
      if (comment.id == commentId) {
        return updater(comment);
      }
      return comment;
    }).toList();

    emit(state.copyWith(comments: updatedComments));
  }

  // Reset pagination
  void _resetPagination() {
    emit(state.copyWith(
      currentPage: 1,
      hasMore: true,
      comments: [],
    ));
  }

  // Clear error
  void clearError() {
    emit(state.copyWith(error: null));
  }

  // Load more comments
  Future<void> loadMoreComments(String videoId) async {
    if (!state.hasMore || state.isLoading) return;
    await getVideoComments(videoId);
  }
}
