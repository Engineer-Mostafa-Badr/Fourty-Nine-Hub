import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_comment_reply_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/repositories/twitter_repo.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class TwitterCommentReplyUseCase extends UseCase<TwitterCommentReplyEntity, TwitterCommentReplyParams> {
  final TwitterRepo _repo;
  TwitterCommentReplyUseCase(this._repo);
  @override
  Future<Either<Failure, TwitterCommentReplyEntity>> call(TwitterCommentReplyParams params) async {
    return await _repo.replyOnComment(params: params);
  }
}



class TwitterCommentReplyParams {
  final String postId;
  final String reply;
  final String content;
  TwitterCommentReplyParams({
    required this.postId,
    required this.reply,
    required this.content,
  });
  Map<String, dynamic> toJson() => {
    'content': content,
    'reply': reply,
    'postId': postId,
  };
}
