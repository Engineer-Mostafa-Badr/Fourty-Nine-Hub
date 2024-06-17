import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';

import '../../../../../res/assets/jsons.dart';

abstract class AdsRemoteDataSource {
  Future<Either<Failure, List<AdModel>>> getAds({required int subCategoryId});
}

class AdsRemoteDataSourceImpl implements AdsRemoteDataSource {
  final JsonParser _apiConsumer;
  AdsRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<AdModel>>> getAds(
      {required int subCategoryId}) async {
    final response = await _apiConsumer.get(Jsons.adsList);
    return response.fold((failure) => Left(failure), (response) => Right((response['data']['ads'] as List).map((e) => AdModel.fromJson(e)).toList()));
  }
}
