import 'package:fourtyninehub/core/abstract/use_case.dart';

import '../../entities/get_client_offer_trips_entity.dart';
import '../../repositories/ride_repository.dart';

class ListenToOfferUpdateUntrackedTripUseCase
    extends NormalUseCase<void, Function(ClientOfferTripEntity)> {
  final RideRepository _repo;
  ListenToOfferUpdateUntrackedTripUseCase(this._repo);

  @override
  void call(Function(ClientOfferTripEntity trip) params) {
    return _repo.listenToOfferUpdateUntrackedTrip(params);
  }
}
