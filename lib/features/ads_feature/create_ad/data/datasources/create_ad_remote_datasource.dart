import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/data/models/ad_property_model.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/ad_properties_entity.dart';

import '../../../../../res/assets/jsons.dart';

abstract class CreateAdRemoteDatasource {
  Future<Either<Failure, List<AdPropertiesEntity>>> getAdProperties({
    required String subCategoryId,
  });
}

class CreateAdRemoteDatasourceImpl implements CreateAdRemoteDatasource {
  final JsonParser _apiConsumer;
  CreateAdRemoteDatasourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<AdPropertiesEntity>>> getAdProperties(
      {required String subCategoryId}) async {
    final response = await _apiConsumer.get(Jsons.adProperties);
    return response.fold((failure) => Left(failure), (data) => Right(
      (data['data']['properties'] as List).map((e) => AdPropertyModel.fromJson(e)).toList()
    ));
  }
}
