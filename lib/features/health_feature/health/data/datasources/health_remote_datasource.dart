import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/health/data/models/appointment_booking_model.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/res/assets/jsons.dart';

abstract class HealthRemoteDataSource {
  Future<Either<Failure, List<AppointmentBookingEntity>>> getMyBookings();
}

class HealthRemoteDataSourceImpl implements HealthRemoteDataSource {
  final JsonParser _apiConsumer;
  HealthRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<AppointmentBookingEntity>>>
      getMyBookings() async {
    final response = await _apiConsumer.get(Jsons.doctorBookingsList);
    return response.fold((failure) => Left(failure), (data) => Right(
      (data['data']['bookings'] as List).map((e) => AppointmentBookingModel.fromJson(e)).toList()
    ));
  }
}
