import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';

import '../../domain/repositories/doctor_details_repo.dart';
import '../datasources/doctor_detail_remote_datasource.dart';

class DoctorDetailsRepoImpl implements DoctorDetailsRepo {
  final DoctorDetailsRemoteDataSource _remoteDataSource;
  DoctorDetailsRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, DoctorEntity>> getDoctorDetails(
      {required int id}) async {
    return await _remoteDataSource.getDoctorDetails(id: id);
  }
}
