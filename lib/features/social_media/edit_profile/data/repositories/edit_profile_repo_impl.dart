import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../../health_feature/create_doctor/domain/entities/governorate_entity.dart';

import '../../domain/entities/edit_profile_entity.dart';

import '../../domain/repositories/edit_profile_repo.dart';
import '../datasources/edit_profile_remote_datasource.dart';

class EditProfileRepoImpl implements EditProfileRepo {
  final EditProfileRemoteDataSource _remoteDataSource;
  EditProfileRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, bool>> editProfile(
      {required EditProfileEntity params}) {
    return _remoteDataSource.editProfile(params: params);
  }

  @override
  Future<Either<Failure, List<GovernorateEntity>>> getGovernorates() {
    return _remoteDataSource.getGovernorates();
  }
}
