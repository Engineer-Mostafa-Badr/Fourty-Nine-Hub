import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_model_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetRideNonTrackingModelsUseCase
    extends UseCase<List<RideModelEntity>, String> {
  final RideRepository _repo;
  GetRideNonTrackingModelsUseCase(this._repo);

  @override
  Future<Either<Failure, List<RideModelEntity>>> call(String params) {
    return _repo.getRideNonTrackingModels(params);
  }
}
