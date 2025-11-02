import '../../../../core/abstract/use_case.dart';
import '../repositories/auction_repo.dart';

class LeaveToAuctionUseCase extends NormalUseCase<void, String> {
  final AuctionRepository _repo;
  LeaveToAuctionUseCase(this._repo);

  @override
  void call(String auctionId) {
    return _repo.leaveAuction(auctionId);
  }
}
