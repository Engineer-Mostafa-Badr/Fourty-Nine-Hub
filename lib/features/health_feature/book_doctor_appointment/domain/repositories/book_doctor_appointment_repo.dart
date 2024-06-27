import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../doctor_details/domain/entities/appointment_entity.dart';

abstract class BookAppointmentRepo {
  Future<Either<Failure, List<AppointmentEntity>>> getDoctorAppointments({
    required DateTime date,
  });
}