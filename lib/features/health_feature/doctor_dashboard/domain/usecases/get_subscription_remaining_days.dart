import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/repositories/doctor_dashboard_repo.dart';

class GetDoctorSubscriptionRemainingDaysUseCase extends UseCase<int, NoParams> {
  final DoctorDashboardRepo _repo;
  GetDoctorSubscriptionRemainingDaysUseCase(this._repo);

  @override
  Future<Either<Failure, int>> call(NoParams params) {
    return _repo.getSubscriptionRemainingDays();
  }
}
