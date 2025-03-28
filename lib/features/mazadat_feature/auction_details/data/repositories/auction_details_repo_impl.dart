import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_details/domain/entities/bidding_entity.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_details/domain/usecases/send_bidding_usecase.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_list/domain/entities/auction_entity.dart';

import '../../domain/repositories/auction_details_repo.dart';
import '../datasources/auction_details_remote_datasource.dart';

class AuctionDetailsRepoImpl implements AuctionDetailsRepo {
  final AuctionDetailsRemoteDataSource _remoteDataSource;
  AuctionDetailsRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, bool>> followUserAuctions(
      {required String userId}) async {
    return await _remoteDataSource.followUserAuctions(userId: userId);
  }

  @override
  Future<Either<Failure, AuctionEntity>> getAuctionDetails(
      {required String id}) async {
    return await _remoteDataSource.getAuctionDetails(id: id);
  }

  @override
  Future<Either<Failure, bool>> sendAuction(
      {required SendBiddingParams params}) async {
    return await _remoteDataSource.sendAuction(params: params);
  }

  @override
  Future<Either<Failure, bool>> finishAuction({required String id}) {
    return _remoteDataSource.finishAuction(id: id);
  }

  @override
  Future<Either<Failure, List<BiddingEntity>>> getAuctionRequests(
      {required String id}) {
    return _remoteDataSource.getAuctionRequests(id: id);
  }
}
