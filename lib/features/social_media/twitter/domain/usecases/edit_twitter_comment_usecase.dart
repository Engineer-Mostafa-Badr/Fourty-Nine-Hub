import 'package:dartz/dartz.dart';
import '../repositories/twitter_repo.dart';
import 'post_comment_usecase.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class EditTwitterCommentUseCase
    extends UseCase<bool, TwitterPostCommentParams> {
  final TwitterRepo _repo;
  EditTwitterCommentUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(TwitterPostCommentParams params) async {
    return await _repo.editComment(params: params);
  }
}
