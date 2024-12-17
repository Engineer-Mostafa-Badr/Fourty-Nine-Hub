import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';

import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/domain/usecases/get_subcategory_doctors_list_usecase.dart';

import '../../../../../core/error/failure.dart';
import '../../../doctor_details/data/models/doctor_model.dart';
import '../../domain/usecases/get_doctor_list_usecase.dart';

abstract class DoctorListRemoteDataSource {
  Future<Either<Failure, List<DoctorEntity>>> getDoctorsList(
      {required DoctorSearchParams params});
  Future<Either<Failure, List<DoctorEntity>>> getSubCategoryDoctorsList(
      {required GetSubCategoryDoctorsParams params});
}

class DoctorListRemoteDataSourceImpl implements DoctorListRemoteDataSource {
  final ApiConsumer _apiConsumer;

  DoctorListRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<DoctorEntity>>> getDoctorsList(
      {required DoctorSearchParams params}) async {
    print("objectFromSearch${params.toJson()}");
    final response = await _apiConsumer.get(EndPoints.doctorSearch,
        data: params.toJson(),
      queryParameters: {
      "page":params.page,
        "limit":params.limit
      }
        );

    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data'] as List)
            .map((e) => DoctorModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<DoctorEntity>>> getSubCategoryDoctorsList({required GetSubCategoryDoctorsParams params}) async {
    print("objectFromSubCat$params");
    final response = await _apiConsumer.get(
      EndPoints.doctorSearch,
      data: {
      'subCategoryId': params.subCategoryId
      },
      queryParameters: params.toJson()
    );
    return response.fold(
            (failure) => Left(failure),
            (data) => Right((data['data'] as List)
            .map((e) => DoctorModel.fromJson(e))
            .toList()));
  }
}
