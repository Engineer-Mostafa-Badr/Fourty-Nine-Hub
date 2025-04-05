
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_offer_entity.dart';

import '../../../../core/abstract/use_case.dart';
import '../repositories/ride_repository.dart';

class ListenToRideOffersUseCase
    extends NormalUseCase<void, Function(RideOfferEntity)> {
  final RideRepository _repo;
  ListenToRideOffersUseCase(this._repo);

  @override
  void call(Function(RideOfferEntity offer) params) {
    return _repo.listenToRideOffers(params);
  }
}
