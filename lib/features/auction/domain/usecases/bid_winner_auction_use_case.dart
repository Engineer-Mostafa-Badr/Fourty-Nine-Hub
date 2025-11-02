import '../../../../core/abstract/use_case.dart';
import '../entities/listen_winner_bid_entity.dart';
import '../repositories/auction_repo.dart';

class BidWinnerAuctionUseCase
    extends NormalUseCase<void, Function(BidWinnerEntity)> {
  final AuctionRepository _repo;
  BidWinnerAuctionUseCase(this._repo);

  @override
  void call(Function(BidWinnerEntity error) onError) {
    return _repo.listenToBidWinner(onError);
  }
}
