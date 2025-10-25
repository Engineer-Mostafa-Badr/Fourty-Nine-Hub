import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/spotlight/domain/entities/spotlight_entity.dart';

import '../../domain/repositories/spotlight_repo.dart';

import '../datasource/spotlight_remote_datasource.dart';

class SpotlightRepoImpl implements SpotlightRepository {
  final SpotlightRemoteDataSource _remoteDataSource;
  SpotlightRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, SpotlightEntity>> getSpotLight() {
    return _remoteDataSource.getSpotLight();
  }

  // @override
  // Future<Either<Failure, List<GetAvailableAuctionEntity>>> getAvailableAuction({required GetAuctionParams params}) {
  //   return _remoteDataSource.getAvailableAuction(params: params);
  // }







}
