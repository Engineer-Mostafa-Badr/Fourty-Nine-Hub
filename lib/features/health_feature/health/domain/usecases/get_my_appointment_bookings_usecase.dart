import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/health_repo.dart';

class GetMyAppointmentBookingsHistoryUseCase
    extends UseCase<List<BookedAppointmentEntity>, NoParams> {
  final HealthRepo _repo;
  GetMyAppointmentBookingsHistoryUseCase(this._repo);

  @override
  Future<Either<Failure, List<BookedAppointmentEntity>>> call(NoParams params) {
    return _repo.getMyBookingsHistory();
  }
}
