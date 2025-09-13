import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/auction_main_category_entity.dart';
import '../entities/auction_participants_entity.dart';
import '../entities/auction_sub_category_entity.dart';
import '../entities/get_all_auction_entity.dart';
import '../usecases/fetch_available_auction_use_case.dart';
import '../usecases/fetch_participants_auction_use_case.dart';
import '../usecases/fetch_single_auction_use_case.dart';
import '../usecases/fetch_sub_category_auction_use_case.dart';

abstract class AuctionRepository {

  Future<Either<Failure, List<GetAvailableAuctionEntity >>> getAvailableAuction({required GetAuctionParams params});
  Future<Either<Failure, List<GetAvailableAuctionEntity >>> getExpiredAuction({required GetAuctionParams params});
  Future<Either<Failure, List<GetAvailableAuctionEntity >>> getFavoriteAuction({required GetAuctionParams params});
  Future<Either<Failure, List<AuctionMainCategoryEntity>>> getAuctionMainCategory({required GetAuctionParams params});
  Future<Either<Failure, List<AuctionSubCategoryEntity>>> getAuctionSubCategory({required GetSubCategoryAuctionParams params});


  Future<Either<Failure, GetAvailableAuctionEntity>> getSingleAuction({required SingleAuctionParams params});
  Future<Either<Failure, List<AuctionParticipantsEntity>>> getParticipantsAuction({required PriceAuctionParams params});

  void listenToNewAuction(Function(GetAvailableAuctionEntity trip) params);
  void listenToNewBidAuction(Function(AuctionParticipantsEntity trip) params);
  void joinAuction(String auctionId);
  Future<void> sendBid(String auctionId, int newPrice);

}
