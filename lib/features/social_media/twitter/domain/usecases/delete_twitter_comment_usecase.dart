import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/repositories/twitter_repo.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class DeleteTwitterCommentUseCase extends UseCase<bool, String> {
  final TwitterRepo _repo;
  DeleteTwitterCommentUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(String params) async {
    return await _repo.deleteComment(commentId: params);
  }
}
