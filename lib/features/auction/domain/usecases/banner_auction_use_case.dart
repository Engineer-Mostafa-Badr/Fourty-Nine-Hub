import 'package:dartz/dartz.dart';


import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/add_favorite_auction_entity.dart';
import '../entities/auction_banner_entity.dart';
import '../repositories/auction_repo.dart';

class BannerAuctionUseCase extends UseCase<AuctionBannerEntity  , NoParams> {
  final AuctionRepository _repo;

  BannerAuctionUseCase(this._repo);
  @override
  Future<Either<Failure, AuctionBannerEntity >> call(NoParams params) async {
    return await _repo.bannerAuction();
  }

}




