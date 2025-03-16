import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/cost_per_km_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

class GetCostPerKmUseCase
    extends UseCase<CostPerKmEntity, NoParams> {
  final RideRepository _repo;
  GetCostPerKmUseCase(this._repo);

  @override
  Future<Either<Failure, CostPerKmEntity>> call(NoParams params) {
    return _repo.getCostPerKm();
  }
}
