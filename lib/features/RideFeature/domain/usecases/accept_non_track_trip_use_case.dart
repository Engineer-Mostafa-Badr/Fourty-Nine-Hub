import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/create_no_track_trip_entity.dart';
import '../repositories/ride_repository.dart';

class AcceptNonTrackTripUseCase
    extends UseCase<CreateNonTrackTripEntity, AcceptNonTrackTripParams> {
  final RideRepository _repo;

  AcceptNonTrackTripUseCase(this._repo);

  @override
  Future<Either<Failure, CreateNonTrackTripEntity>> call(AcceptNonTrackTripParams params) {
    return _repo.acceptNonTrackTrip(params);
  }
}
class AcceptNonTrackTripParams {
  final String tripsId;

  AcceptNonTrackTripParams({required this.tripsId});
}
