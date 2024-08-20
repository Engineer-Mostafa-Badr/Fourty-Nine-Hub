import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/repositories/create_doctor_repo.dart';

class GetGovernoratesUseCase
    extends UseCase<List<GovernorateEntity>, NoParams> {
  final CreateDoctorRepo _createDoctorRepo;

  GetGovernoratesUseCase(this._createDoctorRepo);

  @override
  Future<Either<Failure, List<GovernorateEntity>>> call(NoParams params) {
    return _createDoctorRepo.getGovernorates();
  }
}
