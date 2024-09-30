import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/my_ads_trip_join_entity.dart';

import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_entity.dart';
import 'package:fourtyninehub/features/ride/trip_details/domain/entities/trip_and_request_entity.dart';

import '../../domain/entity/my_ads_auction.dart';
import '../../domain/repositories/my_ads_repo.dart';
import '../datasources/my_add_remote_datasource.dart';

class MyAdsRepoImpl implements MyAdsRepo {
  final MyAdsRemoteDatasource _remoteDatasource;
  MyAdsRepoImpl(this._remoteDatasource);
  @override
  Future<Either<Failure, bool>> cancelAd({required String id}) {
    return _remoteDatasource.cancelAd(id: id);
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

  @override
  Future<Either<Failure, bool>> acceptComeWithYouRequests(
      {required String id}) {
    return _remoteDatasource.acceptComeWithYouRequests(id: id);
  }

  @override
  Future<Either<Failure, bool>> acceptPickMeRequest({required String id}) {
    return _remoteDatasource.acceptPickMeRequest(id: id);
  }

  @override
  Future<Either<Failure, bool>> rejectComeWithYouRequests(
      {required String id}) {
    return _remoteDatasource.rejectComeWithYouRequests(id: id);
  }

  @override
  Future<Either<Failure, bool>> rejectPickMeRequest({required String id}) {
    return _remoteDatasource.rejectPickMeRequest(id: id);
  }

  @override
  Future<Either<Failure, List<MyAuctionAdsEntity>>> getMyAuctions() {
    return _remoteDatasource.getMyAuctions();
  }

  @override
  Future<Either<Failure, List<MyAuctionAdsEntity>>> getMyInstallments() {
   return _remoteDatasource.getMyInstallments();
  }

  @override
  Future<Either<Failure, MyAdsTripJoinEntity>> getMyTripJoin() {
   return _remoteDatasource.getMyTripJoin();
  }

  @override
  Future<Either<Failure, bool>> deleteMyTripJoin({required String id}) {
    return _remoteDatasource.deleteMyTripJoin(id: id);
  }

  @override
  Future<Either<Failure, bool>> deleteMyInstallment({required String id}) {
   return _remoteDatasource.deleteMyInstallment(id: id);
  }

  @override
  Future<Either<Failure, List<MyAuctionAdsEntity>>> getMyOtherAds() {
    return _remoteDatasource.getMyOtherAds();
  }
}
