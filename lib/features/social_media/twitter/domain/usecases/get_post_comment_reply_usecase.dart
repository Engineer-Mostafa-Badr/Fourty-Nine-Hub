import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_comment_reply_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/twitter_repo.dart';

class GetTwitterCommentRepliesUseCase extends UseCase<List<TwitterCommentReplyEntity>, String> {
  final TwitterRepo _repo;
  GetTwitterCommentRepliesUseCase(this._repo);
  @override
  Future<Either<Failure, List<TwitterCommentReplyEntity>>> call(String params) async {
    return await _repo.getCommentReplies(commentId: params);
  }
}
