import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class DeleteCommentUseCase extends UseCase<bool, DeleteCommentParams> {
  final InstagramRepo _repo;
  DeleteCommentUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(DeleteCommentParams params) async {
    return await _repo.deleteComment(params);
  }
}

class DeleteCommentParams {
  final String postId;
  final String commentId;

  DeleteCommentParams({
    required this.postId,
    required this.commentId,
  });
}
