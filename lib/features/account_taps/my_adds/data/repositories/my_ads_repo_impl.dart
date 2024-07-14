import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_entity.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/trip_entity.dart';
import 'package:fourtyninehub/features/ride/trip_details/domain/entities/trip_and_request_entity.dart';

import '../../../../ride/trip_details/data/models/trip_and_request_model.dart';
import '../../domain/repositories/my_ads_repo.dart';
import '../datasources/my_add_remote_datasource.dart';

class MyAdsRepoImpl implements MyAdsRepo {
  final MyAdsRemoteDatasource _remoteDatasource;
  MyAdsRepoImpl(this._remoteDatasource);
  @override
  Future<Either<Failure, bool>> cancelAd({required int id}) {
    // TODO: implement cancelAd
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> deactivateAd({required int id}) {
    // TODO: implement deactivateAd
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<AdEntity>>> getAds() async {
    return await _remoteDatasource.getAds();
  }

  @override
  Future<Either<Failure, bool>> deleteComeWithMeAd({required String id}) {
    return _remoteDatasource.deleteComeWithMeAd(id: id);
  }

  @override
  Future<Either<Failure, bool>> deletePickMeAd({required String id}) {
    return _remoteDatasource.deleteComeWithMeAd(id: id);
  }

  @override
  Future<Either<Failure, List<TripAndRequestEntity>>> getComeWithMeAds() {
    return _remoteDatasource.getComeWithMeAds();
  }

  @override
  Future<Either<Failure, List<TripAndRequestEntity>>> getPickMeAds() {
    return _remoteDatasource.getPickMeAds();
  }
}
