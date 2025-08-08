import 'package:dartz/dartz.dart';
import '../entities/twitter_post_comment_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/twitter_repo.dart';

class TwitterPostCommentUseCase
    extends UseCase<TwitterPostCommentEntity, TwitterPostCommentParams> {
  final TwitterRepo _repo;
  TwitterPostCommentUseCase(this._repo);
  @override
  Future<Either<Failure, TwitterPostCommentEntity>> call(
      TwitterPostCommentParams params) async {
    return await _repo.commentOnTwitterPost(params: params);
  }
}

class TwitterPostCommentParams {
  final String postId;
  final String content;
  TwitterPostCommentParams({
    required this.postId,
    required this.content,
  });
  Map<String, dynamic> toJson() => {
        'content': content,
        // 'subCategory':'66a3583454e6e337915514db'
      };
}
