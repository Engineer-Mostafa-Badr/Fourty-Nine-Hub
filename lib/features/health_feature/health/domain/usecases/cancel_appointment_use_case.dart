import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/health/data/models/doctor_info_model.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/doctor_info_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/repositories/health_repo.dart';

class CancelAppointmentUseCase extends UseCase<bool, String> {
  final HealthRepo _repo;

  CancelAppointmentUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repo.cancelAppointment(params);
  }
}
