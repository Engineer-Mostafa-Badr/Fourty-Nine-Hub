import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/mazadat_feature/create_auction/domain/usecases/create_auction_usecase.dart';

import '../../domain/repositories/create_auction_repo.dart';
import '../datasources/create_auction_remotedata_source.dart';

class CreateAuctionRepoImpl implements CreateAuctionRepo {
  final CreateAuctionRemoteDataSource _remoteDataSource;
  CreateAuctionRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, bool>> createAuction(
      {required CreateAuctionParams params}) {
    return _remoteDataSource.createAuction(params: params);
  }
}
