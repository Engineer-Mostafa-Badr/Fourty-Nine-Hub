import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/data/model/click_model.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/data/model/edit_my_ads_model.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/data/model/my_ads_trip_join_model.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/edit_my_ads_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ride/trip_details/domain/entities/trip_and_request_entity.dart';

import '../../../../../core/data/datasources/json_parser.dart';
import '../../../../../core/error/failure.dart';
import '../../../../ads_feature/ads/domain/entities/ad_entity.dart';
import '../../../../ride/trip_details/data/models/trip_and_request_model.dart';
import '../../domain/entity/click_entity.dart';
import '../../domain/entity/get_all_count_ads_entity.dart';
import '../../domain/entity/get_all_counts_trip_join_entity.dart';
import '../../domain/entity/my_ads_auction.dart';
import '../../domain/entity/my_ads_trip_join_entity.dart';
import '../../domain/usecases/click_use_case.dart';
import '../../domain/usecases/edit_my_ads_use_case.dart';
import '../../domain/usecases/get_all_counts_ads_usecase.dart';
import '../../domain/usecases/get_all_counts_usecase.dart';
import '../../domain/usecases/update_my_ads_usecase.dart';
import '../model/get_all_count_ads_model.dart';
import '../model/get_all_counts_trip_join_model.dart';
import '../model/my_ads_auction_model.dart';

abstract class MyAdsRemoteDatasource {
  Future<Either<Failure, List<AdEntity>>> getAds();
  Future<Either<Failure, List<TripAndRequestEntity>>> getComeWithMeAds();
  Future<Either<Failure, List<TripAndRequestModel>>> getPickMeAds();
  Future<Either<Failure, List<MyAuctionAdsEntity>>> getMyAuctions();
  Future<Either<Failure, List<MyAuctionAdsEntity>>> getMyInstallments();
  Future<Either<Failure, List<MyAuctionAdsEntity>>> getMyOtherAds();
  Future<Either<Failure, MyAdsTripJoinEntity>> getMyTripJoin();
  Future<Either<Failure, bool>> deleteComeWithMeAd({required String id});
  Future<Either<Failure, bool>> deletePickMeAd({required String id});
  Future<Either<Failure, bool>> acceptPickMeRequest({required String id});
  Future<Either<Failure, bool>> rejectPickMeRequest({required String id});
  Future<Either<Failure, bool>> acceptComeWithYouRequests({required String id});
  Future<Either<Failure, bool>> rejectComeWithYouRequests({required String id});
  Future<Either<Failure, bool>> cancelAd({required String id});
  Future<Either<Failure, bool>> deactivateAd({required int id});
  Future<Either<Failure, bool>> deleteMyTripJoin({required String id});
  Future<Either<Failure, bool>> deleteMyInstallment({required String id});
  Future<Either<Failure, List<GetAllCountsTripJoinEntity>>>
      getAllCountsTripJoin(Params params);
  Future<Either<Failure, List<GetAllCountAdsEntity>>> getAllCountsAds(
      CountAdsParams params);
  Future<Either<Failure, bool>> updateMyAds(UpdateMyAdsParams params);
  Future<Either<Failure, bool>> editMyAds(EditParams params);
  Future<Either<Failure, ClickEntity>> click(ClickParams params);
  Future<Either<Failure, EditMyAdsEntity>> fetchMyAdsById({required String id});
}

class MyAdsRemoteDatasourceImpl implements MyAdsRemoteDatasource {
  final ApiConsumer _apiConsumer;
  final JsonParser _jsonParser;
  MyAdsRemoteDatasourceImpl(this._apiConsumer, this._jsonParser);
  @override
  Future<Either<Failure, bool>> cancelAd({required String id}) async {
    final response = await _apiConsumer.delete(EndPoints.deleteAd(id));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> deactivateAd({required int id}) {
    // TODO: implement deactivateAd
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<AdEntity>>> getAds() async {
    final response = await _apiConsumer.get(EndPoints.myAds);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['ads'] as List)
            .map((e) => AdModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, bool>> deleteComeWithMeAd({required String id}) async {
    final response =
        await _apiConsumer.delete(EndPoints.deleteComeWithYouTrips(id));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> deletePickMeAd({required String id}) async {
    final response = await _apiConsumer.delete(EndPoints.deletePickMeTrips(id));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, List<TripAndRequestEntity>>> getComeWithMeAds() async {
    final response = await _apiConsumer.get(EndPoints.getMyComeWithYouTrips);
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data'] as List)
            .map((e) => TripAndRequestModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<TripAndRequestModel>>> getPickMeAds() async {
    final response = await _apiConsumer.get(EndPoints.getMyPickMeTrips);
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data']['requests'] as List)
            .map((e) => TripAndRequestModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, bool>> acceptComeWithYouRequests(
      {required String id}) async {
    final response =
        await _apiConsumer.put(EndPoints.acceptComeWithYouRequest(id));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> acceptPickMeRequest(
      {required String id}) async {
    final response = await _apiConsumer.put(EndPoints.acceptPickMeRequest(id));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> rejectComeWithYouRequests(
      {required String id}) async {
    final response =
        await _apiConsumer.put(EndPoints.rejectComeWithYouRequest(id));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> rejectPickMeRequest(
      {required String id}) async {
    final response = await _apiConsumer.put(EndPoints.rejectPickMeRequest(id));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, List<MyAuctionAdsEntity>>> getMyAuctions() async {
    final response = await _apiConsumer.get(EndPoints.myAdsAuction);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['ads'] as List)
            .map((e) => MyAuctionAdsModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<MyAuctionAdsEntity>>> getMyInstallments() async {
    final response = await _apiConsumer.get(EndPoints.myAdsInstallment);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['ads'] as List)
            .map((e) => MyAuctionAdsModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, MyAdsTripJoinEntity>> getMyTripJoin() async {
    final response = await _apiConsumer.get(EndPoints.myAdsTripJoin);
    return response.fold((failure) => Left(failure),
        (data) => Right(MyAdsTripJoinModel.fromJson(data['data']['trips'])));
  }

  @override
  Future<Either<Failure, bool>> deleteMyTripJoin({required String id}) async {
    final response =
        await _apiConsumer.delete(EndPoints.deleteMyTripJoin(id: id));
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> deleteMyInstallment(
      {required String id}) async {
    final response =
        await _apiConsumer.delete(EndPoints.deleteMyInstallment(id: id));
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, List<MyAuctionAdsEntity>>> getMyOtherAds() async {
    final response = await _apiConsumer.get(EndPoints.myAdsOther);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['ads'] as List)
            .map((e) => MyAuctionAdsModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<GetAllCountsTripJoinEntity>>>
      getAllCountsTripJoin(Params params) async {
    final response = await _apiConsumer.get(EndPoints.getAllCount(params));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data'] as List)
            .map((e) => GetAllCountsTripJoinModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<GetAllCountAdsEntity>>> getAllCountsAds(
      CountAdsParams params) async {
    final response = await _apiConsumer.get(EndPoints.getAllAdsCount(params));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data'] as List)
            .map((e) => GetAllCountAdsModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, bool>> updateMyAds(UpdateMyAdsParams params) async {
    final response = await _apiConsumer.put(EndPoints.updateMyAds(params),
        data: params.toJson());
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> editMyAds(EditParams params) async {
    final response = await _apiConsumer.put(EndPoints.editMyAds(params),
        data: params.toJson());
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, ClickEntity>> click(ClickParams params) async {
    final response =
        await _apiConsumer.post(EndPoints.clickGlobal, data: params.toJson());
    return response.fold(
        (failure) => Left(failure), (data) => Right(ClickModel.fromJson(data)));
  }

  @override
  Future<Either<Failure, EditMyAdsEntity>> fetchMyAdsById(
      {required String id}) async {
    final response = await _apiConsumer.get(EndPoints.getMyAdsWithId(id: id));
    return response.fold((failure) => Left(failure),
        (data) => Right(EditMyAdsModel.fromJson(data['data'])));
  }
}
