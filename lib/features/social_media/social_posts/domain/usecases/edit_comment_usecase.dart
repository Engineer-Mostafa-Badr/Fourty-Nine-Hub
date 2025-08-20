import 'package:dartz/dartz.dart';
import 'post_comment_usecase.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class EditCommentUseCase extends UseCase<bool, PostCommentParams> {
  final SocialPostsRepo _repo;
  EditCommentUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(PostCommentParams params) async {
    return await _repo.editComment(params: params);
  }
}
