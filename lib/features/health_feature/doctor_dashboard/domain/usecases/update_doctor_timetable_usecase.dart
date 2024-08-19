import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/repositories/doctor_dashboard_repo.dart';

class UpdateDoctorTimetableUsecase
    extends UseCase<bool, DoctorTimetableParams> {
  final DoctorDashboardRepo _repo;

  UpdateDoctorTimetableUsecase(this._repo);

  @override
  Future<Either<Failure, bool>> call(params) {
    return _repo.updateTimetable(params);
  }
}

class DoctorTimetableParams {}
