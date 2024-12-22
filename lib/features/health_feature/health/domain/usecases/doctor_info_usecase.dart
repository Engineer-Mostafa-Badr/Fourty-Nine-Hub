import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/doctor_info_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/repositories/health_repo.dart';

class DoctorInfoUseCase extends UseCase<DoctorInfoEntity, NoParams> {
  final HealthRepo _repo;

  DoctorInfoUseCase(this._repo);

  @override
  Future<Either<Failure, DoctorInfoEntity>> call(NoParams params) {
    return _repo.getDoctorInfo();
  }
}
