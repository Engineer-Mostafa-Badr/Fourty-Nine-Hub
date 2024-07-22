import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/repositories/ads_repo.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/trip_entity.dart';

import '../../domain/usecases/request_come_with_me_usecase.dart';
import '../datasources/ads_remote_data_source.dart';

class AdsRepoImpl implements AdsRepo {
  final AdsRemoteDataSource _remoteDataSource;
  AdsRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<AdModel>>> getAds(
      {required String subCategoryId}) async {
    return await _remoteDataSource.getAds(subCategoryId: subCategoryId);
  }

  @override
  Future<Either<Failure, List<TripEntity>>> getComeWithMeAds() {
    return _remoteDataSource.getComeWithMeAds();
  }

  @override
  Future<Either<Failure, List<TripEntity>>> getPickMeAds() {
    return _remoteDataSource.getPickMeAds();
  }

  @override
  Future<Either<Failure, bool>> requestComeWithMe({required RequestParams params}) {
    return _remoteDataSource.requestComeWithMe(params: params);
  }

  @override
  Future<Either<Failure, bool>> requestPickMe({required RequestParams params}) {
    return _remoteDataSource.requestPickMe(params: params);
  }
}
