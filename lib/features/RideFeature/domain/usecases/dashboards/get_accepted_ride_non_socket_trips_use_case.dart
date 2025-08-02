import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../entities/dashboards/get_accepted_ride_non_socket_trip_entity.dart';
import '../../repositories/trip_repository.dart';
import '../get_client_pending_untracked_trips_use_case.dart';


class GetAcceptedNonSocketTripsUseCase extends UseCase<List<AcceptedRideNonSocketTripEntity > , ClientPendingTripParams> {
  final TripRepository _repo;

  GetAcceptedNonSocketTripsUseCase(this._repo);

  @override
  Future<Either<Failure, List<AcceptedRideNonSocketTripEntity >>> call(ClientPendingTripParams params) async {
    return await _repo.getAcceptedNonSocketTrips( params);
  }
}
