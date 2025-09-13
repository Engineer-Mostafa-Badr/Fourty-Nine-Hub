import '../../../../core/abstract/use_case.dart';
import '../entities/get_all_auction_entity.dart';
import '../repositories/auction_repo.dart';

class BidAuctionUseCase extends NormalUseCase<void, BidAuctionParams> {
  final AuctionRepository _repo;
  BidAuctionUseCase(this._repo);

  @override
  Future<void> call(BidAuctionParams params) {
    return _repo.sendBid(params.auctionId, params.newPrice);
  }
}

class BidAuctionParams {
  final String auctionId;
  final int newPrice;

  BidAuctionParams({required this.auctionId, required this.newPrice});
}
