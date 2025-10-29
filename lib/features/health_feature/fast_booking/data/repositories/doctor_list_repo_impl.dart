import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/fast_booking/domain/usecases/get_subcategory_doctors_list_usecase.dart';
import 'package:fourtyninehub/features/health_feature/fast_booking/domain/usecases/get_doctors_by_specialty_usecase.dart';

import '../../../health/domain/entities/most_booking_entity.dart';
import '../../domain/repositories/doctor_list_repo.dart';
import '../../domain/usecases/get_doctor_list_use_case.dart';
import '../datasources/doctor_list_remote_datasource.dart';

class DoctorListRepoImpl implements DoctorListRepo {
  final DoctorListRemoteDataSource _remoteDataSource;
  DoctorListRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<MostBookingEntity>>> getDoctorsList(
      {required GetDoctorListParams params}) async {
    return await _remoteDataSource.getDoctorsList(params: params);
  }

  @override
  Future<Either<Failure, List<MostBookingEntity>>> getDoctorsBySpecialty(
      {required GetDoctorsBySpecialtyParams params}) async {
    return await _remoteDataSource.getDoctorsBySpecialty(params: params);
  }

  @override
  Future<Either<Failure, List<DoctorEntity>>> getSubCategoryDoctorsList(
      {required GetSubCategoryDoctorsParams params}) async {
    return await _remoteDataSource.getSubCategoryDoctorsList(params: params);
  }
}
