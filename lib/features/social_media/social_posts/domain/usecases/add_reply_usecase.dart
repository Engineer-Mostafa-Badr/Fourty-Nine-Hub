

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class ReplyOnCommentUseCase extends UseCase<CommentEntity, ReplyOnCommentParams> {
  final SocialPostsRepo _repo;
  ReplyOnCommentUseCase(this._repo);
  @override
  Future<Either<Failure, CommentEntity>> call(ReplyOnCommentParams params) async {
    return await _repo.replyOnComment(params: params);
  }
}



class ReplyOnCommentParams {
  final String postId;
  final String commentId;
  final String content;
  ReplyOnCommentParams({
    required this.postId,
    required this.commentId,
    required this.content,
  });
  Map<String, dynamic> toJson() => {
    'content': content,
    'reply': commentId,
  };
}
