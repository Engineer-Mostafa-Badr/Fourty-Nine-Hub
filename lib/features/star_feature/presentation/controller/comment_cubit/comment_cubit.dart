// lib/features/star_feature/presentation/controller/comment_cubit/comment_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
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
    if (refresh) {
      _resetPagination();
    }

    if (state.isLoading || (!state.hasMore && !refresh)) return;

    emit(state.copyWith(isLoading: true));

    final response = await _getCommentsUseCase(GetCommentsParams(
      videoId: videoId,
      page: state.currentPage,
      limit: 20,
    ));

    response.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        error: failure.toString(),
      )),
      (commentsResponse) {
        final newComments = refresh 
            ? commentsResponse.comments
            : [...state.comments, ...commentsResponse.comments];
        
        emit(state.copyWith(
          isLoading: false,
          comments: newComments,
          currentPage: state.currentPage + 1,
          hasMore: commentsResponse.pagination.page < commentsResponse.pagination.pages,
          totalComments: commentsResponse.pagination.total,
          error: null,
        ));
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
      (failure) => emit(state.copyWith(
        isCreatingComment: false,
        error: failure.toString(),
      )),
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

  // Like a comment
  Future<void> likeComment(String commentId) async {
    // Optimistic update
    _updateCommentLocally(commentId, (comment) => comment.copyWith(
      likes: comment.likes + 1,
      isLiked: true,
      isDisliked: false,
    ));

    final response = await _likeCommentUseCase(commentId);

    response.fold(
      (failure) {
        // Revert optimistic update
        _updateCommentLocally(commentId, (comment) => comment.copyWith(
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
    _updateCommentLocally(commentId, (comment) => comment.copyWith(
      dislikes: comment.dislikes + 1,
      isDisliked: true,
      isLiked: false,
    ));

    final response = await _dislikeCommentUseCase(commentId);

    response.fold(
      (failure) {
        // Revert optimistic update
        _updateCommentLocally(commentId, (comment) => comment.copyWith(
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
  Future<void> deleteComment(String commentId) async {
    final response = await _deleteCommentUseCase(commentId);

    response.fold(
      (failure) => emit(state.copyWith(error: failure.toString())),
      (success) {
        final updatedComments = state.comments
            .where((comment) => comment.id != commentId)
            .toList();
        
        emit(state.copyWith(
          comments: updatedComments,
          totalComments: state.totalComments - 1,
        ));
      },
    );
  }

  // Update a comment
  Future<void> updateComment(String commentId, String newContent) async {
    final response = await _updateCommentUseCase(UpdateCommentParams(
      commentId: commentId,
      content: newContent,
    ));

    response.fold(
      (failure) => emit(state.copyWith(error: failure.toString())),
      (success) {
        _updateCommentLocally(commentId, (comment) => comment.copyWith(
          content: newContent,
        ));
      },
    );
  }

  // Helper method to update a comment locally
  void _updateCommentLocally(String commentId, CommentModel Function(CommentModel) updater) {
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