import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/repositories/doctor_dashboard_repo.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';

class GetDoctorProfileUseCase extends UseCase<DoctorEntity, NoParams> {
  final DoctorDashboardRepo _repo;

  GetDoctorProfileUseCase(this._repo);

  @override
  Future<Either<Failure, DoctorEntity>> call(NoParams params) {
    return _repo.getDoctorProfile();
  }
}
