import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/shipping_repository.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/create_loading_trip_model.dart';
import '../entities/create_loading_trip_entity.dart';
import '../entities/create_no_track_trip_entity.dart';
import '../repositories/ride_repository.dart';

class CancelNonTrackTripUseCase
    extends UseCase<CreateNonTrackTripEntity, CancelNonTrackTripParams> {
  final RideRepository _repo;

  CancelNonTrackTripUseCase(this._repo);

  @override
  Future<Either<Failure, CreateNonTrackTripEntity>> call(CancelNonTrackTripParams params) {
    return _repo.cancelNonTrackTrip(params);
  }
}
class CancelNonTrackTripParams {
  final List<String> tripsIds;

  CancelNonTrackTripParams({required this.tripsIds});
}
