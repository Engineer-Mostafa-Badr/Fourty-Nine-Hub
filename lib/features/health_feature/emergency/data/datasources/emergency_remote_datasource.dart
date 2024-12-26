import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/emergency/data/model/emergency_model.dart';
import 'package:fourtyninehub/features/health_feature/emergency/domain/entities/emergency_entity.dart';
import 'package:fourtyninehub/features/health_feature/emergency/domain/usecases/book_emergency.dart';
import 'package:fourtyninehub/features/health_feature/emergency/domain/usecases/get_emergency_requests_use_case.dart';

abstract class HealthEmergencyRemoteDataSource {
  Future<Either<Failure, bool>> bookEmergency(BookHealthEmergencyParams params);
  Future<Either<Failure, List<EmergencyEntity>>> getEmergencyRequests(
      GetEmergencyRequestsParams params);
}

class HealthEmergencyRemoteDataSourceImpl
    implements HealthEmergencyRemoteDataSource {
  final ApiConsumer _apiConsumer;
  HealthEmergencyRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, bool>> bookEmergency(
      BookHealthEmergencyParams params) async {
    final response = await _apiConsumer.post(
      EndPoints.bookEmergency,
      data: params.toJson(),
      queryParameters: {'subCategory': params.subCategoryId},
    );

    return response.fold((l) => Left(l), (r) => Right(r['status'] as bool));
  }

  @override
  Future<Either<Failure, List<EmergencyEntity>>> getEmergencyRequests(
      GetEmergencyRequestsParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.emergencyRequests(params),
    );

    return response.fold(
        (l) => Left(l),
        (r) => Right((r['data'] as List)
            .map((e) => EmergencyModel.fromJson(e))
            .toList()));
  }
}

/*
(data['data'] as List)
          .map((e) => RideThumbnailModel.fromJson(e))
          .toList()
 */
