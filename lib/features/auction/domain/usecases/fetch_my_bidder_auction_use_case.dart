import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/my_bidders_entity.dart';
import '../repositories/auction_repo.dart';
import 'fetch_available_auction_use_case.dart';

class GetMyBiddersAuctionUseCase extends UseCase<List<MyBiddersEntity  >, GetAuctionParams> {
  final AuctionRepository _repo;

  GetMyBiddersAuctionUseCase(this._repo);

  @override
  Future<Either<Failure, List<MyBiddersEntity  >>> call(GetAuctionParams params) async {
    return await _repo.getMyBidderAuction(params:params);
  }
}
