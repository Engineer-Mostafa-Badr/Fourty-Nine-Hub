import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/requests_history/data/models/trip_model.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/trip_entity.dart';

import '../../domain/usecases/request_come_with_me_usecase.dart';

abstract class AdsRemoteDataSource {
  Future<Either<Failure, List<AdModel>>> getAds(
      {required String subCategoryId});
  Future<Either<Failure, List<TripEntity>>> getComeWithMeAds();
  Future<Either<Failure, List<TripEntity>>> getPickMeAds();
  Future<Either<Failure, bool>> requestPickMe({required RequestParams params});
  Future<Either<Failure, bool>> requestComeWithMe(
      {required RequestParams params});
}

class AdsRemoteDataSourceImpl implements AdsRemoteDataSource {
  final ApiConsumer _apiConsumer;

  AdsRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<AdModel>>> getAds(
      {required String subCategoryId}) async {
    final response =
        await _apiConsumer.get(EndPoints.subCategoryAds(subCategoryId));
    return response.fold(
        (failure) => Left(failure),
        (response) => Right((response['data'] as List)
            .map((e) => AdModel.fromJson(e))
            .toList()));
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
}
