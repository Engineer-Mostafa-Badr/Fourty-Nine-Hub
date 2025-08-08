import 'package:dartz/dartz.dart';
import 'post_follow_user_instagram_use_case.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class UnFollowUserInstagramUseCase
    extends UseCase<bool, PostFollowUserInstagramParams> {
  final InstagramRepo _repo;
  UnFollowUserInstagramUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(
      PostFollowUserInstagramParams params) async {
    return await _repo.unFollowUserInstagram(params);
  }
}
