import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/repositories/twitter_repo.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_comment_usecase.dart';

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
