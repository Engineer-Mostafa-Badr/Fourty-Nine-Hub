import 'package:dartz/dartz.dart';
import '../entities/comment_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class GetPostCommentsUseCase
    extends UseCase<List<CommentEntity>, PostCommentsParams> {
  final SocialPostsRepo _repo;
  GetPostCommentsUseCase(this._repo);
  @override
  Future<Either<Failure, List<CommentEntity>>> call(
      PostCommentsParams params) async {
    return await _repo.getPostComments(params: params);
  }
}

class PostCommentsParams {
  final int? page;
  final String? id;
  final int? limit;
  final String? postId;
  final String? userId;
  const PostCommentsParams({
    this.page,
    this.limit,
    this.userId,
    this.postId,
    this.id,
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    if (page != null) {
      data['page'] = page;
    }
    if (limit != null) {
      data['limit'] = limit;
    }
    if (postId != null) {
      data['postId'] = postId;
    }
    return data;
  }
}
