import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/click_entity.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/get_all_count_ads_entity.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/get_all_counts_trip_join_entity.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/my_ads_trip_join_entity.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/click_use_case.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/edit_my_ads_use_case.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/get_all_counts_ads_usecase.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/get_all_counts_usecase.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/update_my_ads_usecase.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/edit_my_ads_entity.dart';

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

  @override
  Future<Either<Failure, List<GetAllCountsTripJoinEntity>>>
      getAllCountsTripJoin(Params params) {
    return _remoteDatasource.getAllCountsTripJoin(params);
  }

  @override
  Future<Either<Failure, List<GetAllCountAdsEntity>>> getAllCountsAds(
      CountAdsParams params) {
    return _remoteDatasource.getAllCountsAds(params);
  }

  @override
  Future<Either<Failure, bool>> updateMyAds(UpdateMyAdsParams params) {
    return _remoteDatasource.updateMyAds(params);
  }

  @override
  Future<Either<Failure, bool>> editMyAds(EditParams params) {
    return _remoteDatasource.editMyAds(params);
  }

  @override
  Future<Either<Failure, ClickEntity>> click(ClickParams params) {
    return _remoteDatasource.click(params);
  }

  @override
  Future<Either<Failure, EditMyAdsEntity>> fetchMyAdsById(
      {required String id}) {
    return _remoteDatasource.fetchMyAdsById(id: id);
  }
}
