import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/edit_profile/domain/entities/edit_profile_entity.dart';

import '../../../../health_feature/create_doctor/domain/entities/governorate_entity.dart';

abstract class EditProfileRepo {
  Future<Either<Failure, bool>> editProfile(
      {required EditProfileEntity params});
  Future<Either<Failure, List<GovernorateEntity>>> getGovernorates();

}
