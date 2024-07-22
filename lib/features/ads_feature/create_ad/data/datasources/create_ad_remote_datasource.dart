import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/data/models/ad_property_model.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/ad_properties_entity.dart';

import '../../../../../core/api/end_points.dart';

abstract class CreateAdRemoteDatasource {
  Future<Either<Failure, List<AdPropertiesEntity>>> getAdProperties({
    required String subCategoryId,
  });
  Future<Either<Failure, bool>> creatAd({required AdModel ad});
}

class CreateAdRemoteDatasourceImpl implements CreateAdRemoteDatasource {
  final ApiConsumer _apiConsumer;
  CreateAdRemoteDatasourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<AdPropertiesEntity>>> getAdProperties(
      {required String subCategoryId}) async {
    final response =
        await _apiConsumer.get(EndPoints.getSubcategoryAdProps(subCategoryId));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data'] as List)
            .map((e) => AdPropertyModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, bool>> creatAd({required AdModel ad}) async {
    final response =
        await _apiConsumer.post(EndPoints.createAd, data: ad.toJson());
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }
}
