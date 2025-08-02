import 'package:fourtyninehub/core/abstract/use_case.dart';

import '../../entities/get_client_offer_trips_entity.dart';
import '../../repositories/ride_repository.dart';

class ListenToOfferUpdateShippingTripUseCase
    extends NormalUseCase<void, Function(ClientOfferTripEntity)> {
  final RideRepository _repo;
  ListenToOfferUpdateShippingTripUseCase(this._repo);

  @override
  void call(Function(ClientOfferTripEntity trip) params) {
    return _repo.listenToOfferUpdateShippingTrip(params);
  }
}
