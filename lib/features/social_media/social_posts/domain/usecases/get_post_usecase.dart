import 'package:dartz/dartz.dart';
import '../entities/post_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class GetPostUseCase extends UseCase<PostEntity, String> {
  final SocialPostsRepo _repo;
  GetPostUseCase(this._repo);
  @override
  Future<Either<Failure, PostEntity>> call(String params) async {
    return await _repo.getPost(postId: params);
  }
}
