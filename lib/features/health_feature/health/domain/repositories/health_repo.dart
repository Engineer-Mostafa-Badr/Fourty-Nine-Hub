import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../entities/appointment_booking_entity.dart';

abstract class HealthRepo {
  Future<Either<Failure, List<BookedAppointmentEntity>>> getMyBookingsHistory();

  Future<Either<Failure, List<BookedAppointmentEntity>>> getUpcomingBookings();
}
