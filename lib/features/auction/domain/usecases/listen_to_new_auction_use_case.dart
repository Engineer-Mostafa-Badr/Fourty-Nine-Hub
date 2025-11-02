import 'package:fourtyninehub/core/abstract/use_case.dart';

import '../entities/get_all_auction_entity.dart';
import '../repositories/auction_repo.dart';

class ListenToNewAuctionUseCase
    extends NormalUseCase<void, Function(GetAvailableAuctionEntity)> {
  final AuctionRepository _repo;
  ListenToNewAuctionUseCase(this._repo);

  @override
  void call(Function(GetAvailableAuctionEntity trip) params) {
    return _repo.listenToNewAuction(params);
  }
}
