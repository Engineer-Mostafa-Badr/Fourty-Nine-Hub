import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/shipping_repository.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/cancel_non_track_trip_use_case.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/create_loading_trip_model.dart';
import '../entities/create_loading_trip_entity.dart';
import '../entities/create_no_track_trip_entity.dart';
import '../repositories/ride_repository.dart';

class CancelShippingTripUseCase
    extends UseCase<CreateNonTrackTripEntity, CancelNonTrackTripParams> {
  final RideRepository _repo;

  CancelShippingTripUseCase(this._repo);

  @override
  Future<Either<Failure, CreateNonTrackTripEntity>> call(CancelNonTrackTripParams params) {
    return _repo.cancelShippingTrip(params);
  }
}
