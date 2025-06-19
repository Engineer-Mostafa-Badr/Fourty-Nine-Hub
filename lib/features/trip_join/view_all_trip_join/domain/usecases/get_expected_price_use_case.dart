import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../../ride/RideRequest/domain/entity/expected_price_entity.dart';
import '../entities/expected_price_entity.dart';
import '../repos/view_all_trip_join_repo.dart';

class GetExpectedPriceTripUseCase
    extends UseCase<ExpectedPriceTripEntity, ExpectedPriceTripParams> {
  final ViewAllTripJoinRepo _repo;
  GetExpectedPriceTripUseCase(this._repo);

  @override
  Future<Either<Failure, ExpectedPriceTripEntity>> call(ExpectedPriceTripParams params) {
    return _repo.getExpectedPrice(params);
  }
}

class ExpectedPriceTripParams {
  final List<double> startLocation;
  final List<double> targetLocation;

  ExpectedPriceTripParams({
    required this.startLocation,
    required this.targetLocation,
  });

  Map<String, dynamic> toJson() {
    return {
      'startLocation': startLocation,
      'targetLocation': targetLocation,
    };
  }
}
