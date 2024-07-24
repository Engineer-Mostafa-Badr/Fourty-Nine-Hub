import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../auction_list/domain/entities/auction_entity.dart';

abstract class AuctionDetailsRepo {
  Future<Either<Failure, AuctionEntity>> getAuctionDetails({required String id});
  Future<Either<Failure, bool>> sendAuction();
  Future<Either<Failure, bool>> followUserAuctions({required int userId});
}