import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_details/domain/usecases/send_bidding_usecase.dart';

import '../../../../../core/error/failure.dart';
import '../../../auction_list/domain/entities/auction_entity.dart';
import '../entities/bidding_entity.dart';

abstract class AuctionDetailsRepo {
  Future<Either<Failure, AuctionEntity>> getAuctionDetails(
      {required String id});
  Future<Either<Failure, bool>> sendAuction(
      {required SendBiddingParams params});
  Future<Either<Failure, bool>> followUserAuctions({required String userId});
  Future<Either<Failure, bool>> finishAuction({required String id});
  Future<Either<Failure, List<BiddingEntity>>> getAuctionRequests(
      {required String id});
}
