import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/repositories/doctor_dashboard_repo.dart';

class UpdateDoctorPersonalInfoUsecase
    extends UseCase<bool, DoctorPersonalInfoParams> {
  final DoctorDashboardRepo _repo;

  UpdateDoctorPersonalInfoUsecase(this._repo);

  @override
  Future<Either<Failure, bool>> call(params) {
    return _repo.updatePersonalInfo(params);
  }
}

class DoctorPersonalInfoParams {}
