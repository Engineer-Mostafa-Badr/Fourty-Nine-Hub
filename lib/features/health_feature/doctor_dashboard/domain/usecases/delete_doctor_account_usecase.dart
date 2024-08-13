import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/repositories/doctor_dashboard_repo.dart';

class DeleteDoctorAccountUseCase extends UseCase<bool, String> {
  final DoctorDashboardRepo doctorDashboardRepo;

  DeleteDoctorAccountUseCase(this.doctorDashboardRepo);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return doctorDashboardRepo.deleteAccount(params);
  }
}
