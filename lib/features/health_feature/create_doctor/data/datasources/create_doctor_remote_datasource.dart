import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/data/models/governrate_model.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/create_doctor.dart';
import 'package:fourtyninehub/features/health_feature/shared/data/models/city_model.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/entities/city_entity.dart';

abstract class CreateDoctorRemoteDataSource {
  Future<Either<Failure, bool>> createDoctor(CreateDoctorParams params);

  Future<Either<Failure, List<GovernorateEntity>>> getGovernorates();

  Future<Either<Failure, List<CityEntity>>> getCities(String governorateId);

  Future<Either<Failure, bool>> uploadDocuments(List<DocumentParams> documents);
}

class CreateDoctorRemoteDataSourceImpl implements CreateDoctorRemoteDataSource {
  final ApiConsumer _apiConsumer;

  CreateDoctorRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, bool>> createDoctor(CreateDoctorParams params) async {
    final response =
        await _apiConsumer.post(EndPoints.createDoctor, data: params.toJson());

    return response.fold(
      (failure) => Left(failure),
      (data) => Right(data['status']),
    );
  }

  // removed old update method (no longer part of interface)

  @override
  Future<Either<Failure, List<CityEntity>>> getCities(
      String governorateId) async {
    final response = await _apiConsumer.get(
        '${EndPoints.getCities(governorateId: governorateId)}?page=1&limit=10');
    return response.fold(
      (failure) => Left(failure),
      (data) => Right(((data['data']?['cities'] ?? data['data']) as List)
          .map((e) => CityModel.fromJson(e))
          .cast<CityEntity>()
          .toList()),
    );
  }

  @override
  Future<Either<Failure, List<GovernorateEntity>>> getGovernorates() async {
    final response =
        await _apiConsumer.get('${EndPoints.getGovernorates}?page=1&limit=10');
    return response.fold(
        (failure) => Left(failure),
        (data) => Right(
              ((data['data']?['governorate'] ?? data['data']) as List)
                  .map((e) => GovernorateModel.fromJson(e))
                  .toList(),
            ));
  }

  @override
  Future<Either<Failure, bool>> uploadDocuments(
      List<DocumentParams> documents) async {
    final response =
        await _apiConsumer.put(EndPoints.uploadDoctorDocuments, data: {
      'documents': documents.map((e) => e.toJson()).toList(),
    });
    return response.fold(
      (failure) => Left(failure),
      (data) => Right(data['status'] == true),
    );
  }
}
