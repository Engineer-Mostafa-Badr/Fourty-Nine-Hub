import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/available_ride_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/available_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

class AvailableRideTripsUseCase extends UseCase<List<AvailableTripEntity>, AvailableRideTripsUseCaseParams> {
  final RideRepository _repo;
  AvailableRideTripsUseCase(this._repo);

  @override
  Future<Either<Failure, List<AvailableTripEntity>>> call(AvailableRideTripsUseCaseParams params) {
    return _repo.getAvailableRideTrips(params);
  }
}
class AvailableRideTripsUseCaseParams{
  final int page;
  final int limit;

  AvailableRideTripsUseCaseParams({required this.page,required this.limit});
}

