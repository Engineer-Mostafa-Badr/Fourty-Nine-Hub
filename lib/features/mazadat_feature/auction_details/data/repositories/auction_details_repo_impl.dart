import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/mazadat_feature/auction_list/domain/entities/auction_entity.dart';

import '../../domain/repositories/auction_details_repo.dart';
import '../datasources/auction_details_remote_datasource.dart';

class AuctionDetailsRepoImpl implements AuctionDetailsRepo {
  final AuctionDetailsRemoteDataSource _remoteDataSource;
  AuctionDetailsRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, bool>> followUserAuctions(
      {required int userId}) async {
    return await _remoteDataSource.followUserAuctions(userId: userId);
  }

  @override
  Future<Either<Failure, AuctionEntity>> getAuctionDetails(
      {required String id}) async {
    return await _remoteDataSource.getAuctionDetails(id: id);
  }

  @override
  Future<Either<Failure, bool>> sendAuction() async {
    return await _remoteDataSource.sendAuction();
  }
}
