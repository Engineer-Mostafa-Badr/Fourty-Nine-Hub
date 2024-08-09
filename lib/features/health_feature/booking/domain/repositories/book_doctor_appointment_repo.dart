import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/usecases/book_regular_appointment.dart';

import '../../../../../core/error/failure.dart';

abstract class BookAppointmentRepo {
  Future<Either<Failure, bool>> bookRegularAppointment(
      BookAppointmentParams params);

       Future<Either<Failure, bool>> bookPremiumAppointment(
      BookAppointmentParams params);
}
