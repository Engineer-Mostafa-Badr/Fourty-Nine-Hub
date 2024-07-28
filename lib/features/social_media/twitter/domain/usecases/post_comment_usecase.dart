

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/twitter_repo.dart';

class TwitterPostCommentUseCase extends UseCase<bool, PostCommentParams> {
  final TwitterRepo _repo;
  TwitterPostCommentUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(PostCommentParams params) async {
    return await _repo.commentOnTwitterPost(params: params);
  }
}


