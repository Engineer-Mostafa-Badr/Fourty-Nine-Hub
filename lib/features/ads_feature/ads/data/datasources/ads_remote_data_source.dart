import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/get_ads_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/get_my_ad_by_id_usecase.dart';
import 'package:fourtyninehub/features/requests_history/data/models/trip_model.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/trip_entity.dart';

import '../../domain/usecases/request_come_with_me_usecase.dart';

abstract class AdsRemoteDataSource {
  Future<Either<Failure, List<AdModel>>> getAds({required GetAdsParams params});

  Future<Either<Failure, List<TripEntity>>> getComeWithMeAds();

  Future<Either<Failure, List<TripEntity>>> getPickMeAds();

  Future<Either<Failure, bool>> requestPickMe({required RequestParams params});

  Future<Either<Failure, bool>> favouriteAd({required String params});

  Future<Either<Failure, bool>> removeFavouriteAd({required String params});

  Future<Either<Failure, bool>> requestComeWithMe(
      {required RequestParams params});

  Future<Either<Failure, List<AdModel>>> getMyAdById(GetMyAdByIdParams params);
  Future<Either<Failure, List<AdModel>>> getMyAdFavouriteAds(
      GetMyAdByIdParams params);
}

class AdsRemoteDataSourceImpl implements AdsRemoteDataSource {
  final ApiConsumer _apiConsumer;

  AdsRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<AdModel>>> getAds(
      {required GetAdsParams params}) async {
    try {
      final response = await _apiConsumer.get(EndPoints.subCategoryAds(params));
      return response.fold(
          (failure) => Left(failure),
          (response) => Right((response['data']['ads'] as List)
              .map((e) => AdModel.fromJson(e))
              .toList()));
    } catch (e) {
      print(e);
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TripEntity>>> getComeWithMeAds() async {
    final response = await _apiConsumer.get(EndPoints.getAllComeWithMeAds);
    return response.fold(
        (l) => Left(l),
        (data) => Right(
            (data['data'] as List).map((e) => TripModel.fromJson(e)).toList()));
  }

  @override
  Future<Either<Failure, List<TripEntity>>> getPickMeAds() async {
    final response = await _apiConsumer.get(EndPoints.getAllPickMeAds);
    return response.fold(
        (l) => Left(l),
        (data) => Right(
            (data['data'] as List).map((e) => TripModel.fromJson(e)).toList()));
  }

  @override
  Future<Either<Failure, bool>> requestComeWithMe(
      {required RequestParams params}) async {
    final response = await _apiConsumer.post(
        EndPoints.requestComeWithMe(params.subCategoryId),
        data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> requestPickMe(
      {required RequestParams params}) async {
    final response = await _apiConsumer.post(
        EndPoints.requestPickMe(params.subCategoryId),
        data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> favouriteAd({required String params}) async {
    final response = await _apiConsumer.post(
      EndPoints.favouriteAd(params),
    );
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> removeFavouriteAd(
      {required String params}) async {
    final response = await _apiConsumer.delete(
      EndPoints.removeFavouriteAd(params),
    );
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, List<AdModel>>> getMyAdById(
      GetMyAdByIdParams params) async {
    final response =
        await _apiConsumer.get(EndPoints.myAdsByCategoryId(params: params));
    try {
      return response.fold(
          (failure) => Left(failure),
          (data) => Right((data['data']['ads'] as List)
              .map((e) => AdModel.fromJson(e))
              .toList()));
    } catch (e) {
      print(e);
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AdModel>>> getMyAdFavouriteAds(
      GetMyAdByIdParams params) async {
    final response = await _apiConsumer.get(EndPoints.myFavouriteAds(params));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['ads'] as List)
            .map((e) => AdModel.fromJson(e))
            .toList()));
  }
}
