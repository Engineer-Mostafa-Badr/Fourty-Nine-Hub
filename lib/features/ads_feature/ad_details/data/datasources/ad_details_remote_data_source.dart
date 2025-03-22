import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/domain/usecases/get_ad_details_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_details_model.dart';
import 'package:fourtyninehub/res/assets/jsons.dart';

import '../../../../../core/error/failure.dart';
import '../../../ads/data/models/Ad_model.dart';
import '../../domain/usecases/make_ad_request_usecase.dart';

abstract class AdDetailsRemoteDataSource {
  Future<Either<Failure, AddDetailsModel>> getAdDetails(
      {required GetAdDetailsParams params});
  Future<Either<Failure, List<AdModel>>> getRelevantAds({required int id});
  Future<Either<Failure, bool>> makeAdRequest(
      {required AdRequestParams params});
  Future<Either<Failure, bool>> makeAdPremiumRequest(
      {required AdRequestParams params});
}

class AdDetailsRemoteDataSourceImpl extends AdDetailsRemoteDataSource {
  final ApiConsumer _apiConsumer;
  AdDetailsRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, AddDetailsModel>> getAdDetails(
      {required GetAdDetailsParams params}) async {
    final response = await _apiConsumer.get(EndPoints.adDetails(params));

    return response.fold((failure) => Left(failure), (data) {
      final item = AddDetailsModel.fromJson(data['data']);
      return Right(item);
    });
  }

  @override
  Future<Either<Failure, List<AdModel>>> getRelevantAds(
      {required int id}) async {
    final response = await _apiConsumer.get(Jsons.userAdsList);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['ads'] as List)
            .map((e) => AdModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, bool>> makeAdRequest(
      {required AdRequestParams params}) async {
    final response =
        await _apiConsumer.post(EndPoints.makeRequest, data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> makeAdPremiumRequest(
      {required AdRequestParams params}) async {
    final response = await _apiConsumer.post(EndPoints.makePremiumRequest,
        data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }
}
