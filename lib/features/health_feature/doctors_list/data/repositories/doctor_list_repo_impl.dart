import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/common/models/public/city_model.dart';

import 'package:fourtyninehub/common/models/public/state_model.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';

import '../../domain/repositories/doctor_list_repo.dart';
import '../../domain/usecases/get_doctor_list_usecase.dart';
import '../datasources/doctor_list_remote_datasource.dart';

class DoctorListRepoImpl implements DoctorListRepo {
  final DoctorListRemoteDataSource _remoteDataSource;
  DoctorListRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<CityModel>>> getCities(
      {required int stateId}) async {
    return await _remoteDataSource.getCities(stateId: stateId);
  }

  @override
  Future<Either<Failure, List<DoctorEntity>>> getDoctorsList(
      {    required DoctorSearchParams params
}) async {
    return await _remoteDataSource.getDoctorsList(
       params: params);
  }

  @override
  Future<Either<Failure, List<StateModel>>> getStates() async {
    return await _remoteDataSource.getStates();
  }
}
