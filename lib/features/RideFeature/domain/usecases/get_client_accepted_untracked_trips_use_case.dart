import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/get_client_accepted_trips_entity.dart';
import '../entities/get_client_pending_trips_entity.dart';
import '../repositories/ride_repository.dart';
import 'get_client_pending_untracked_trips_use_case.dart';

class GetClientAcceptedUntrackedTripsUseCase extends UseCase<List<ClientAcceptedTripEntity > , ClientPendingTripParams> {
  final RideRepository _repo;

  GetClientAcceptedUntrackedTripsUseCase(this._repo);

  @override
  Future<Either<Failure, List<ClientAcceptedTripEntity >>> call(ClientPendingTripParams params) async {
    return await _repo.getClientAcceptedUntrackedTrips(params: params);
  }
}
