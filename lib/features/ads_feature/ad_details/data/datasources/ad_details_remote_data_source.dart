import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/res/assets/jsons.dart';

import '../../../../../core/error/failure.dart';
import '../../../ads/data/models/Ad_model.dart';

abstract class AdDetailsRemoteDataSource {
  Future<Either<Failure, AdModel>> getAdDetails({required int id});
  Future<Either<Failure, List<AdModel>>> getRelevantAds({required int id});
}

class AdDetailsRemoteDataSourceImpl extends AdDetailsRemoteDataSource {
  final JsonParser _apiConsumer;
  AdDetailsRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, AdModel>> getAdDetails({required int id}) async {
    final response = await _apiConsumer.get(Jsons.adDetails);

    return response.fold((failure) => Left(failure), (data) {
      final item = AdModel.fromJson(data['data']);
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
}
