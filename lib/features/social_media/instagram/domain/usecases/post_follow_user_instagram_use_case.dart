import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class PostFollowUserInstagramUseCase
    extends UseCase<bool, PostFollowUserInstagramParams> {
  final InstagramRepo _repo;
  PostFollowUserInstagramUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(
      PostFollowUserInstagramParams params) async {
    return await _repo.postFollowUserInstagram(params);
  }
}

class PostFollowUserInstagramParams {
  final String userId;
  PostFollowUserInstagramParams({required this.userId});
}
