import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/expected_price_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/expected_price_params.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_not_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_not_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/request_trip_params.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetRideExpectedPriceUseCase
    extends UseCase<RideExpectedPriceEntity, RideExpectedPriceParams> {
  final RideRepository _repo;
  GetRideExpectedPriceUseCase(this._repo);

  @override
  Future<Either<Failure, RideExpectedPriceEntity>> call(RideExpectedPriceParams params) {
    return _repo.getExpectedPrice(params);
  }
}
