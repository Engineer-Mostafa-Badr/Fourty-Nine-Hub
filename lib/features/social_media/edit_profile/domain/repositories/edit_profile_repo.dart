import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/edit_profile_entity.dart';

import '../../../../health_feature/create_doctor/domain/entities/governorate_entity.dart';

abstract class EditProfileRepo {
  Future<Either<Failure, bool>> editProfile(
      {required EditProfileEntity params});
  Future<Either<Failure, List<GovernorateEntity>>> getGovernorates();

}
