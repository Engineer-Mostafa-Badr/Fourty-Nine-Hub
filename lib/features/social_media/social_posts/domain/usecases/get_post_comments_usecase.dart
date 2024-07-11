import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class GetPostCommentsUseCase extends UseCase<List<CommentEntity>, String> {
  final SocialPostsRepo _repo;
  GetPostCommentsUseCase(this._repo);
  @override
  Future<Either<Failure, List<CommentEntity>>> call(String params) async {
    return await _repo.getPostComments(postId: params);
  }
}
