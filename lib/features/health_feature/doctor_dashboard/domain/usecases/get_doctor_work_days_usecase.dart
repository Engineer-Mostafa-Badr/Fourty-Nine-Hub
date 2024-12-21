import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_work_days_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/repositories/doctor_dashboard_repo.dart';

class GetDoctorWorkDaysUsecase extends UseCase<DoctorWorkDaysEntity, NoParams> {
  final DoctorDashboardRepo _repo;

  GetDoctorWorkDaysUsecase(this._repo);

  @override
  Future<Either<Failure, DoctorWorkDaysEntity>> call(NoParams params) {
    return _repo.getWorkDays();
  }
}
