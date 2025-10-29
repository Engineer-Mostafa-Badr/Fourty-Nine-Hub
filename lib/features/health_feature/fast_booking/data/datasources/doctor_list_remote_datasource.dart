import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';

import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/fast_booking/domain/usecases/get_subcategory_doctors_list_usecase.dart';
import 'package:fourtyninehub/features/health_feature/fast_booking/domain/usecases/get_doctors_by_specialty_usecase.dart';

import '../../../../../core/error/failure.dart';
import '../../../doctor_details/data/models/doctor_model.dart';
import '../../../health/data/models/most_booking_model.dart';
import '../../../health/domain/entities/most_booking_entity.dart';
import '../../domain/usecases/get_doctor_list_use_case.dart';

abstract class DoctorListRemoteDataSource {
  Future<Either<Failure, List<MostBookingEntity>>> getDoctorsList(
      {required GetDoctorListParams params});
  Future<Either<Failure, List<MostBookingEntity>>> getDoctorsBySpecialty(
      {required GetDoctorsBySpecialtyParams params});
  Future<Either<Failure, List<DoctorEntity>>> getSubCategoryDoctorsList(
      {required GetSubCategoryDoctorsParams params});
}

class DoctorListRemoteDataSourceImpl implements DoctorListRemoteDataSource {
  final ApiConsumer _apiConsumer;

  DoctorListRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<MostBookingEntity>>> getDoctorsList(
      {required GetDoctorListParams params}) async {
    print("objectFromSearch${params.toJson()}");
    final response = await _apiConsumer
        .get(EndPoints.getDoctorList, data: params.toJson(), queryParameters: {
      "page": params.page,
      "limit": params.limit,
      "subCategoryId": params.subCategoryId
    });

    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['doctors'] as List)
            .map((e) => MostBookingModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<MostBookingEntity>>> getDoctorsBySpecialty(
      {required GetDoctorsBySpecialtyParams params}) async {
    print("objectFromSpecialty${params.toJson()}");
    final response = await _apiConsumer.get(
        '${EndPoints.getDoctorsBySpecialty}/${params.specialtyId}',
        queryParameters: {"page": params.page, "limit": params.limit});

    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['doctors'] as List)
            .map((e) => MostBookingModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<DoctorEntity>>> getSubCategoryDoctorsList(
      {required GetSubCategoryDoctorsParams params}) async {
    print("objectFromSubCat$params");
    final response = await _apiConsumer.get(EndPoints.doctorSearch,
        data: {'subCategoryId': params.subCategoryId},
        queryParameters: params.toJson());
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data'] as List)
            .map((e) => DoctorModel.fromJson(e))
            .toList()));
  }
}
