import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/emergency/domain/usecases/book_emergency.dart';

abstract class HealthEmergencyRemoteDataSource {
  Future<Either<Failure, bool>> bookEmergency(BookHealthEmergencyParams params);
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
    );

    return response.fold((l) => Left(l), (r) => Right(r['status'] as bool));
  }
}
