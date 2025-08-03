import 'package:dartz/dartz.dart';
import '../entities/single_post_instagram_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class GetSinglePostInstagramUseCase
    extends UseCase<SinglePostInstagramEntity, String> {
  final InstagramRepo _repo;
  GetSinglePostInstagramUseCase(this._repo);
  @override
  Future<Either<Failure, SinglePostInstagramEntity>> call(String postId) async {
    return await _repo.getSinglePostInstagram(postId);
  }
}
