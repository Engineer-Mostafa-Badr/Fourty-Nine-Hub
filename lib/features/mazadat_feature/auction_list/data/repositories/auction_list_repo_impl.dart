import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/get_nearby_restaurants_usecase.dart';

import 'package:fourtyninehub/features/mazadat_feature/auction_list/domain/entities/auction_entity.dart';

import '../../domain/repositories/auction_list_repo.dart';
import '../datasources/auction_list_remote_date_source.dart';

class AuctionListRepoImpl implements AuctionListRepo {
  final AuctionListRemoteDataSource _remoteDataSource;
  AuctionListRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<AuctionEntity>>> getAuctions(
      {required LocationParams params}) async {
    return await _remoteDataSource.getAuctions(params: params);
  }
}
