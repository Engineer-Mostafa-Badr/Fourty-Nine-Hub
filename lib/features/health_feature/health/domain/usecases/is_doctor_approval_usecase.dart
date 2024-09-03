import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/repositories/health_repo.dart';

class IsDoctorApprovalUsecase extends UseCase<bool, NoParams> {
  final HealthRepo _repo;

  IsDoctorApprovalUsecase(this._repo);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return _repo.isDoctorApproval();
  }
}
