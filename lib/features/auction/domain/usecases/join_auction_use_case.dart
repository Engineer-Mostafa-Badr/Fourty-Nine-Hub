import '../../../../core/abstract/use_case.dart';
import '../entities/get_all_auction_entity.dart';
import '../repositories/auction_repo.dart';

class JoinToAuctionUseCase extends NormalUseCase<void, String> {
  final AuctionRepository _repo;
  JoinToAuctionUseCase(this._repo);

  @override
  void call(String auctionId) {
    return _repo.joinAuction(auctionId);
  }
}
