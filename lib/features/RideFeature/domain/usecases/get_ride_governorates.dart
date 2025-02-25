import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/repositories/create_doctor_repo.dart';

class GetRideGovernoratesUseCase
    extends UseCase<List<GovernorateEntity>, NoParams> {
  final RideRepository _repository;

  GetRideGovernoratesUseCase(this._repository);

  @override
  Future<Either<Failure, List<GovernorateEntity>>> call(NoParams params) {
    return _repository.getGovernorates();
  }
}
