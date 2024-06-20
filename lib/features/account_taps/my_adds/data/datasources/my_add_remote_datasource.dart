import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../res/assets/jsons.dart';
import '../../../../ads_feature/ads/domain/entities/ad_entity.dart';

abstract class MyAdsRemoteDatasource {
  Future<Either<Failure, List<AdEntity>>> getAds();
  Future<Either<Failure, bool>> cancelAd({required int id});
  Future<Either<Failure, bool>> deactivateAd({required int id});
}

class MyAdsRemoteDatasourceImpl implements MyAdsRemoteDatasource {
  final JsonParser _apiConsumer;
  MyAdsRemoteDatasourceImpl(this._apiConsumer);
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
    final response = await _apiConsumer.get(Jsons.adsList);
    return response.fold((failure) => Left(failure), (data) => Right(
      (data['data']['ads'] as List).map((e) => AdModel.fromJson(e)).toList()
    ));
  }
}
