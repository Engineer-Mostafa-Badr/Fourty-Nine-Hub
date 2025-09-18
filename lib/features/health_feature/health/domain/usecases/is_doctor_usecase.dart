import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/doctor_setting_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/repositories/health_repo.dart';

class IsDoctorUsecase extends UseCase<DoctorSettingEntity, NoParams> {
  final HealthRepo _repo;

  IsDoctorUsecase(this._repo);

  @override
  Future<Either<Failure, DoctorSettingEntity>> call(NoParams params) {
    return _repo.isDoctor();
  }
}