import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';

abstract class DoctorDashboardRemoteDataSource {
  Future<Either<Failure, int>> getPracticingRemainingDays(String doctorId);
  Future<Either<Failure, int>> getIDRemainingDays(String doctorId);
  Future<Either<Failure, int>> getSubscriptionRemainingDays(String doctorId);
}

class DoctorDashboardRemoteDataSourceImpl
    implements DoctorDashboardRemoteDataSource {
  final ApiConsumer _apiConsumer;
  DoctorDashboardRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, int>> getPracticingRemainingDays(
      String doctorId) async {
    final response = await _apiConsumer
        .get(EndPoints.remainingDaysOfDoctorPracticing(doctorId));

    return response.fold((l) => Left(l), (r) => Right(r['data'] as int));
  }

  @override
  Future<Either<Failure, int>> getIDRemainingDays(String doctorId) async {
    final response =
        await _apiConsumer.get(EndPoints.remainingDaysOfDoctorID(doctorId));

    return response.fold((l) => Left(l), (r) => Right(r['data'] as int));
  }

  @override
  Future<Either<Failure, int>> getSubscriptionRemainingDays(
      String doctorId) async {
    final response = await _apiConsumer
        .get(EndPoints.remainingDaysOfDoctorSubscription(doctorId));

    return response.fold((l) => Left(l), (r) => Right(r['data'] as int));
  }
}
