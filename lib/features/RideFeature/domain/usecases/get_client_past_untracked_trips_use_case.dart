import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/get_client_accepted_trips_entity.dart';
import '../entities/get_client_past_trips_entity.dart';
import '../entities/get_client_pending_trips_entity.dart';
import '../repositories/ride_repository.dart';
import 'get_client_pending_untracked_trips_use_case.dart';

class GetClientPastUntrackedTripsUseCase extends UseCase<List<ClientPastTripEntity  > , ClientPendingTripParams> {
  final RideRepository _repo;

  GetClientPastUntrackedTripsUseCase(this._repo);

  @override
  Future<Either<Failure, List<ClientPastTripEntity>>> call(ClientPendingTripParams params) async {
    return await _repo.getClientPastUntrackedTrips(params: params);
  }
}
