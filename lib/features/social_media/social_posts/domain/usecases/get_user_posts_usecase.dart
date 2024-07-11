import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class GetUserPostsUseCase extends UseCase<List<PostEntity>, String> {
  final SocialPostsRepo _repo;
  GetUserPostsUseCase(this._repo);
  @override
  Future<Either<Failure, List<PostEntity>>> call(String params) async {
    return await _repo.getUserPosts(userId: params);
  }
}
