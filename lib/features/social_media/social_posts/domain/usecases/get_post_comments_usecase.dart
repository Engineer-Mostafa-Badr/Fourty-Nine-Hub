import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
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
  final int page;
  final int limit;
  final String postId;
  PostCommentsParams({
    required this.page,
    required this.limit,
    required this.postId,
  });
  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
      };
}
