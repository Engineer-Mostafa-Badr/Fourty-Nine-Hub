import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ride/trip_details/domain/entities/trip_and_request_entity.dart';
import '../../../../../core/data/datasources/json_parser.dart';
import '../../../../../core/error/failure.dart';
import '../../../../ads_feature/ads/domain/entities/ad_entity.dart';
import '../../../../ride/trip_details/data/models/trip_and_request_model.dart';

abstract class MyAdsRemoteDatasource {
  Future<Either<Failure, List<AdEntity>>> getAds();
  Future<Either<Failure, List<TripAndRequestEntity>>> getComeWithMeAds();
  Future<Either<Failure, List<TripAndRequestModel>>> getPickMeAds();
  Future<Either<Failure, bool>> deleteComeWithMeAd({required String id});
  Future<Either<Failure, bool>> deletePickMeAd({required String id});
  Future<Either<Failure, bool>> acceptPickMeRequest({required String id});
  Future<Either<Failure, bool>> rejectPickMeRequest({required String id});
  Future<Either<Failure, bool>> acceptComeWithYouRequests({required String id});
  Future<Either<Failure, bool>> rejectComeWithYouRequests({required String id});
  Future<Either<Failure, bool>> cancelAd({required int id});
  Future<Either<Failure, bool>> deactivateAd({required int id});
}

class MyAdsRemoteDatasourceImpl implements MyAdsRemoteDatasource {
  final ApiConsumer _apiConsumer;
  final JsonParser _jsonParser;
  MyAdsRemoteDatasourceImpl(this._apiConsumer, this._jsonParser);
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
    final response = await _apiConsumer.get(EndPoints.myAds);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data'] as List)
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
        (data) => Right((data['data'] as List)
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
}
