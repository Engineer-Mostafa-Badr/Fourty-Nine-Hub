import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/twitter_repo.dart';

class GetTwitterPostCommentRepliesUseCase
    extends UseCase<List<TwitterPostCommentEntity>, PostCommentsParams> {
  final TwitterRepo _repo;
  GetTwitterPostCommentRepliesUseCase(this._repo);
  @override
  Future<Either<Failure, List<TwitterPostCommentEntity>>> call(
      PostCommentsParams params) async {
    return await _repo.getPostComments(params: params);
  }
}
