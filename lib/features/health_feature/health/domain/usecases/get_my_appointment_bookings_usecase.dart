import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/health_repo.dart';

// class GetMyAppointmentBookingsUseCase 

class GetMyAppointmentBookingsUseCase extends UseCase<List<AppointmentBookingEntity>, NoParams> {
  final HealthRepo _repo;
  GetMyAppointmentBookingsUseCase(this._repo);

  @override
  Future<Either<Failure, List<AppointmentBookingEntity>>> call(NoParams params) {
    return _repo.getMyBookings();
  }
}