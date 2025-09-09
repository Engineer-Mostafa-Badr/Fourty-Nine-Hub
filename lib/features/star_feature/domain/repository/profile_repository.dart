import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../entity/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getMyProfile();
  Future<Either<Failure, ProfileEntity>> getProfileById(String profileId);
  Future<Either<Failure, String>> updateProfile(UpdateProfileParams params);
  Future<Either<Failure, List<ProfileEntity>>> searchProfiles(SearchProfileParams params);
}