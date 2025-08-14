import 'package:dartz/dartz.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/social_posts_repo.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class UserProfileUseCase extends UseCase<UserProfileEntity, String> {
  final SocialPostsRepo _repo;
  UserProfileUseCase(this._repo);
  @override
  Future<Either<Failure, UserProfileEntity>> call(String params) async {
    return await _repo.getUserProfile(params: params);
  }
}
