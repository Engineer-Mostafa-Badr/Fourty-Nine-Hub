import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/repositories/health_repo.dart';

class GetUserUpcomingAppointmentsUseCase
    extends UseCase<List<BookedAppointmentEntity>, String> {
  final HealthRepo healthRepo;

  GetUserUpcomingAppointmentsUseCase(this.healthRepo);

  @override
  Future<Either<Failure, List<BookedAppointmentEntity>>> call(String params) {
    return healthRepo.getUpcomingBookings(params);
  }
}
