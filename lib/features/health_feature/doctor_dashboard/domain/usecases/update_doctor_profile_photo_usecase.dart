import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/repositories/doctor_dashboard_repo.dart';

class UpdateDoctorProfilePhotoUsecase extends UseCase<bool, String> {
  final DoctorDashboardRepo _repo;

  UpdateDoctorProfilePhotoUsecase(this._repo);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repo.updateProfilePhoto(params);
  }
}
