import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/usecases/book_appointment.dart';

import '../../../../../core/error/failure.dart';

abstract class BookAppointmentRepo {
  Future<Either<Failure, bool>> bookAppointment(BookAppointmentParams params);
}
