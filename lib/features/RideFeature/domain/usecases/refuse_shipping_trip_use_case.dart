import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/create_no_track_trip_entity.dart';
import '../repositories/ride_repository.dart';
import 'accept_non_track_trip_use_case.dart';

class RefuseShippingTripUseCase
    extends UseCase<CreateNonTrackTripEntity, AcceptNonTrackTripParams> {
  final RideRepository _repo;

  RefuseShippingTripUseCase(this._repo);

  @override
  Future<Either<Failure, CreateNonTrackTripEntity>> call(AcceptNonTrackTripParams params) {
    return _repo.refuseShippingTrip(params);
  }
}
