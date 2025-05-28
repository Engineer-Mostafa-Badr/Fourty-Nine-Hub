import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

class WatchingTripsUseCase extends UseCase<bool, WatchingTripsParams> {
  final RideRepository _repo;

  WatchingTripsUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(WatchingTripsParams params) {
    return _repo.emitWatchingTrips(params);
  }
}

class WatchingTripsParams {
  final List<String> tripIds;
  final String driverImage;
  final String driverId;

  WatchingTripsParams({
    required this.tripIds,
    required this.driverImage,
    required this.driverId,
  });

  Map<String, dynamic> toJson() => {
    'tripIds': tripIds
      };
}
