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
  final double startLongitude;
  final double startLatitude;
  final double targetLongitude;
  final double targetLatitude;

  ExpectedPriceTripParams({
    required this.startLongitude,
    required this.startLatitude,
    required this.targetLongitude,
    required this.targetLatitude,
  });

  Map<String, dynamic> toJson() {
    return {
      "startLocation": {
        "longitude": startLongitude,
        "latitude": startLatitude,
      },
      "targetLocation": {
        "longitude": targetLongitude,
        "latitude": targetLatitude,
      },
    };
  }
}
