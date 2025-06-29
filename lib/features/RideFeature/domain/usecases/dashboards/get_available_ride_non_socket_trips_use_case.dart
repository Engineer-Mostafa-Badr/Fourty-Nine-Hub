import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../entities/dashboards/get_available_ride_non_socket_trip_entity.dart';
import '../../repositories/trip_repository.dart';
import '../get_client_pending_untracked_trips_use_case.dart';


class GetAvailableNonSocketTripsUseCase extends UseCase<List<AvailableRideNonSocketTripEntity> , ClientPendingTripParams> {
  final TripRepository _repo;

  GetAvailableNonSocketTripsUseCase(this._repo);

  @override
  Future<Either<Failure, List<AvailableRideNonSocketTripEntity>>> call(ClientPendingTripParams params) async {
    return await _repo.getAvailableNonSocketTrips( params);
  }
}
