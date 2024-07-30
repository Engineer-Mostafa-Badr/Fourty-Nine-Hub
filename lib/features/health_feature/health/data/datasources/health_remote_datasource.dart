import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/health/data/models/appointment_booking_model.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';

abstract class HealthRemoteDataSource {
  Future<Either<Failure, List<BookedAppointmentEntity>>> getMyBookingsHistory();
  Future<Either<Failure, List<BookedAppointmentEntity>>> getUpcomingBookings();
}

class HealthRemoteDataSourceImpl implements HealthRemoteDataSource {
  final ApiConsumer _apiConsumer;
  HealthRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<BookedAppointmentEntity>>>
      getMyBookingsHistory() async {
    final response = await _apiConsumer.get(EndPoints.getHealthRequestsHistory);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data'] as List)
            .map((e) => BookedAppointmentModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<BookedAppointmentEntity>>>
      getUpcomingBookings() async {
    final response =
        await _apiConsumer.get(EndPoints.getUpcomingUserAppointments);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data'] as List)
            .map((e) => BookedAppointmentModel.fromJson(e))
            .toList()));
  }
}
