import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/repositories/ads_repo.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/get_ads_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/get_my_ad_by_id_usecase.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/trip_entity.dart';

import '../../domain/usecases/request_come_with_me_usecase.dart';
import '../datasources/ads_remote_data_source.dart';

class AdsRepoImpl implements AdsRepo {
  final AdsRemoteDataSource _remoteDataSource;
  AdsRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<AdModel>>> getAds(
      {required GetAdsParams params}) async {
    return await _remoteDataSource.getAds(params: params);
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
  Future<Either<Failure, bool>> requestComeWithMe(
      {required RequestParams params}) {
    return _remoteDataSource.requestComeWithMe(params: params);
  }

  @override
  Future<Either<Failure, bool>> requestPickMe({required RequestParams params}) {
    return _remoteDataSource.requestPickMe(params: params);
  }

  @override
  Future<Either<Failure, bool>> favouriteAd({required String params}) {
    return _remoteDataSource.favouriteAd(params: params);
  }

  @override
  Future<Either<Failure, bool>> removeFavouriteAd({required String params}) {
    return _remoteDataSource.removeFavouriteAd(params: params);
  }

  @override
  Future<Either<Failure, List<AdModel>>> getMyAdById(GetMyAdByIdParams params) {
    return _remoteDataSource.getMyAdById(params);
  }

  @override
  Future<Either<Failure, List<AdModel>>> getMyAdFavouriteAds(
      GetMyAdByIdParams params) {
    return _remoteDataSource.getMyAdFavouriteAds(params);
  }

  @override
  Future<Either<Failure, bool>> viewAd({required String params}) {
    return _remoteDataSource.viewAd(params: params);
  }
}
