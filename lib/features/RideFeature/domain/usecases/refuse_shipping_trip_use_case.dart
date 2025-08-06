import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/shipping_repository.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/create_loading_trip_model.dart';
import '../entities/create_loading_trip_entity.dart';
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
