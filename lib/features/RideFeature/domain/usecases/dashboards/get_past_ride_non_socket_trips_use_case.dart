import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../entities/dashboards/get_past_ride_non_socket_trip_entity.dart';
import '../../repositories/trip_repository.dart';
import '../get_client_pending_untracked_trips_use_case.dart';


class GetPastNonSocketTripsUseCase extends UseCase<List<HistoryTripEntity  > , ClientPendingTripParams> {
  final TripRepository _repo;

  GetPastNonSocketTripsUseCase(this._repo);

  @override
  Future<Either<Failure, List<HistoryTripEntity  >>> call(ClientPendingTripParams params) async {
    return await _repo.getPastNonSocketTrips( params);
  }
}
