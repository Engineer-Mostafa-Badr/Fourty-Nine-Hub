import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/repositories/doctor_dashboard_repo.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetDoctorBookingsUseCase
    extends UseCase<List<BookedAppointmentEntity>, NoParams> {
  final DoctorDashboardRepo _repo;
  GetDoctorBookingsUseCase(this._repo);

  @override
  Future<Either<Failure, List<BookedAppointmentEntity>>> call(NoParams params) {
    return _repo.getDoctorBookings();
  }
}
