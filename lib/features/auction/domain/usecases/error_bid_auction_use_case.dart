import '../../../../core/abstract/use_case.dart';
import '../entities/error_bid_auction_entity.dart';
import '../entities/get_all_auction_entity.dart';
import '../repositories/auction_repo.dart';

class ErrorBidAuctionUseCase
    extends NormalUseCase<void, Function(BidErrorEntity)> {
  final AuctionRepository _repo;
  ErrorBidAuctionUseCase(this._repo);

  @override
  void call(Function(BidErrorEntity error) onError) {
    return _repo.listenToBidError(onError);
  }
}
