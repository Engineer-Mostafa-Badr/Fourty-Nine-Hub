import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class LikePostInstagramUseCase
    extends UseCase<bool, LikePostInstagramParams> {
  final InstagramRepo _repo;
  LikePostInstagramUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(
      LikePostInstagramParams params) async {
    return await _repo.likePostInstagram(params);
  }
}

class LikePostInstagramParams {
  final String postId;
  LikePostInstagramParams({required this.postId});
}
