

import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class PostCommentUseCase extends UseCase<bool, PostCommentParams> {
  final SocialPostsRepo _repo;
  PostCommentUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(PostCommentParams params) async {
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
      };
}
