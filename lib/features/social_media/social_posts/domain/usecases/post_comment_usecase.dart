import 'package:dartz/dartz.dart';
import '../entities/comment_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class PostCommentUseCase extends UseCase<CommentEntity, PostCommentParams> {
  final SocialPostsRepo _repo;
  PostCommentUseCase(this._repo);
  @override
  Future<Either<Failure, CommentEntity>> call(PostCommentParams params) async {
    return await _repo.commentOnPost(params: params);
  }
}

class PostCommentParams {
  final String postId;
  final String content;
  PostCommentParams({
    required this.postId,
    required this.content,
  });
  Map<String, dynamic> toJson() => {
        'content': content,
        // 'subCategory':'66b77e77bb35968b535dc944'
      };
}
