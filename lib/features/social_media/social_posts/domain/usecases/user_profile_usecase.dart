import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/repositories/social_posts_repo.dart';

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
