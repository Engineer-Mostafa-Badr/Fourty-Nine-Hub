import 'package:bloc/bloc.dart';
import '../../../../../../core/error/failure.dart';
import '../../../domain/entities/comment_instagram_entity.dart';
import '../../../domain/usecases/add_comment_use_case.dart';
import '../../../domain/usecases/delete_comment_use_case.dart';
import '../../../domain/usecases/get_comment_use_case.dart';

part 'comments_instagram_state.dart';

class CommentsInstagramCubit extends Cubit<CommentsInstagramState> {
  CommentsInstagramCubit(
    this._getCommentUseCase,
    this._addCommentUseCase,
    this._deleteCommentUseCase,
  ) : super(const CommentsInstagramState());

  final GetCommentUseCase _getCommentUseCase;
  final AddCommentUseCase _addCommentUseCase;
  final DeleteCommentUseCase _deleteCommentUseCase;

  Future<void> getComments(String postId) async {
    emit( CommentsInstagramState(status: CommentsInstagramStatus.loading));
    final result = await _getCommentUseCase(postId);
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: CommentsInstagramStatus.failure,
          failure: failure,
        ));
      },
      (data) {
        emit(state.copyWith(
          status: CommentsInstagramStatus.success,
          comments: data.comments,
        ));
      },
    );
  }

  Future<void> addComment({
    required String postId,
    required String contentComment,
  }) async {
    emit(state.copyWith(addStatus: CommentsAddStatus.loading));
    final result = await _addCommentUseCase(AddCommentParams(
      postId: postId,
      contentComment: contentComment,
    ));
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            addStatus: CommentsAddStatus.failure,
            addFailure: failure,
          ),
        );
      },
      (data) {
        emit(
          state.copyWith(
            addStatus: CommentsAddStatus.success,
          ),
        );
      },
    );
  }

  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    final result = await _deleteCommentUseCase(DeleteCommentParams(
      postId: postId,
      commentId: commentId,
    ));
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            deleteStatus: CommentsDeleteStatus.failure,
            failure: failure,
          ),
        );
      },
      (data) {
        emit(
          state.copyWith(
            deleteStatus: CommentsDeleteStatus.success,
          ),
        );
      },
    );
  }
}
