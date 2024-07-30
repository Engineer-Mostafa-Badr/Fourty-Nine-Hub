import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../res/assets/jsons.dart';
import '../../../health/data/models/appointment_booking_model.dart';
import '../../../health/domain/entities/appointment_booking_entity.dart';

abstract class DoctorDashboardRemoteDataSource {
  Future<Either<Failure, List<BookedAppointmentEntity>>> getDoctorBookings();
  Future<Either<Failure, bool>> changeActiveStatus({required bool status});
  Future<Either<Failure, bool>> cancelBooking({required int id});
  Future<Either<Failure, bool>> confirmBooking({required int id});
}

class DoctorDashboardRemoteDataSourceImpl
    implements DoctorDashboardRemoteDataSource {
  final JsonParser _apiConsumer;
  DoctorDashboardRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, bool>> cancelBooking({required int id}) async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, bool>> changeActiveStatus(
      {required bool status}) async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, bool>> confirmBooking({required int id}) async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, List<BookedAppointmentEntity>>>
      getDoctorBookings() async {
    final response = await _apiConsumer.get(Jsons.doctorBookingsList);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['bookings'] as List)
            .map((e) => BookedAppointmentModel.fromJson(e))
            .toList()));
  }
}
