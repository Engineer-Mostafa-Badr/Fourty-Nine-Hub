import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/available_ride_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';

import '../entities/auction_participants_entity.dart';
import '../entities/get_all_auction_entity.dart';
import '../repositories/auction_repo.dart';

class ListenToNewBidAuctionUseCase
    extends NormalUseCase<void, Function(AuctionParticipantsEntity)> {
  final AuctionRepository _repo;
  ListenToNewBidAuctionUseCase(this._repo);

  @override
  void call(Function(AuctionParticipantsEntity trip) params) {
    return _repo.listenToNewBidAuction(params);
  }
}
