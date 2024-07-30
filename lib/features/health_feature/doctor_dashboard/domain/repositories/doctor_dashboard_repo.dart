import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../health/domain/entities/appointment_booking_entity.dart';

abstract class DoctorDashboardRepo {
  Future<Either<Failure, List<BookedAppointmentEntity>>> getDoctorBookings();
  Future<Either<Failure, bool>> changeActiveStatus({required bool status});
  Future<Either<Failure, bool>> cancelBooking({required int id});
  Future<Either<Failure, bool>> confirmBooking({required int id});
}
