import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_statistics_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetRideModelsUseCase
    extends UseCase<List<String>, String> {
  final RideRepository _repo;
  GetRideModelsUseCase(this._repo);

  @override
  Future<Either<Failure, List<String>>> call(String params) {
    return _repo.getRideModels(params);
  }
}
