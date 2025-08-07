import 'package:dartz/dartz.dart';
import '../../../social_posts/domain/usecases/get_post_comments_usecase.dart';
import '../entities/twitter_comment_reply_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/twitter_repo.dart';

class GetTwitterCommentRepliesUseCase
    extends UseCase<List<TwitterCommentReplyEntity>, PostCommentsParams> {
  final TwitterRepo _repo;
  GetTwitterCommentRepliesUseCase(this._repo);
  @override
  Future<Either<Failure, List<TwitterCommentReplyEntity>>> call(
      PostCommentsParams params) async {
    return await _repo.getCommentReplies(params: params);
  }
}
