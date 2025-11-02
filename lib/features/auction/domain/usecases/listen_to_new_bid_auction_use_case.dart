import 'package:fourtyninehub/core/abstract/use_case.dart';

import '../entities/auction_participants_entity.dart';
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
