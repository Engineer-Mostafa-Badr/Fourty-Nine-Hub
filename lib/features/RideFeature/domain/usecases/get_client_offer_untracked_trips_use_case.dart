import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/get_client_offer_trips_entity.dart';
import '../repositories/ride_repository.dart';
import 'get_client_pending_untracked_trips_use_case.dart';

class GetClientOfferUntrackedTripsUseCase extends UseCase<List<ClientOfferTripEntity > , ClientPendingTripParams> {
  final RideRepository _repo;

  GetClientOfferUntrackedTripsUseCase(this._repo);

  @override
  Future<Either<Failure, List<ClientOfferTripEntity >>> call(ClientPendingTripParams params) async {
    return await _repo.getClientOfferUntrackedTrips(params: params);
  }
}
