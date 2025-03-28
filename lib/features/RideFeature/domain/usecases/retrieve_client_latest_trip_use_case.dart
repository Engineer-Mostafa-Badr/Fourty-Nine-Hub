import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/check_driver_type_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_not_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_not_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/request_trip_params.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_request_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class RetrieveClientLatestTripUseCase
    extends UseCase<RideRequestTripEntity, NoParams> {
  final RideRepository _repo;
  RetrieveClientLatestTripUseCase(this._repo);

  @override
  Future<Either<Failure, RideRequestTripEntity>> call(NoParams params) {
    return _repo.retrieveClientLatestTrip();
  }
}
