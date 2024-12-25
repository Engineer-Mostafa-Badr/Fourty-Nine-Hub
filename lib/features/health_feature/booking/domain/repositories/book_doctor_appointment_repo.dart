import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/entities/all_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/usecases/book_regular_appointment.dart';

import '../../../../../core/error/failure.dart';

abstract class BookAppointmentRepo {
  Future<Either<Failure, bool>> bookRegularAppointment(
      BookAppointmentParams params);
  Future<Either<Failure, bool>> doctorCancelAppointment(String id);

  Future<Either<Failure, List<AllAppointmentEntity>>> allAppointment(
      PaginationParams params);

  Future<Either<Failure, bool>> bookPremiumAppointment(
      BookAppointmentParams params);
}
