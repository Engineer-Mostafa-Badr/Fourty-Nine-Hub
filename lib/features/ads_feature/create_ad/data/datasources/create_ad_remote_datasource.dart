import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/data/models/ad_property_model.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/ad_properties_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/usecases/get_ad_properties_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/data/models/filter_model.dart';

abstract class CreateAdRemoteDatasource {
  Future<Either<Failure, List<AdPropertiesEntity>>> getAdProperties({
    required GetAdPropertiesParams params,
  });
  Future<Either<Failure, bool>> creatAd({required AdModel ad});
  Future<Either<Failure, List<AdModel>>> filterAd({required FilterModel ad});
}

class CreateAdRemoteDatasourceImpl implements CreateAdRemoteDatasource {
  final ApiConsumer _apiConsumer;
  CreateAdRemoteDatasourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<AdPropertiesEntity>>> getAdProperties(
      {required GetAdPropertiesParams params}) async {
    final response =
        await _apiConsumer.get(params.fromMarriage==false?EndPoints.getMainCategoryAdProps(params.id):EndPoints.getSubcategoryAdProps(params.id));
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

  @override
  Future<Either<Failure, List<AdModel>>> filterAd(
      {required FilterModel ad}) async {
    final response =
        await _apiConsumer.post(EndPoints.filterAd(ad), data: ad.toJson());
    return response.fold(
        (failure) => Left(failure),
        (response) => Right((response['data']['allAds']['ads'] as List)
            .map((e) => AdModel.fromJson(e))
            .toList()));
  }
}
