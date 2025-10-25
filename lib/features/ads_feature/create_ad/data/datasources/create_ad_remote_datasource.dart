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
    final response = await _apiConsumer.get(params.fromMarriage == false
        ? EndPoints.getMainCategoryAdProps(params.id)
        : EndPoints.getSubcategoryAdProps(params.id));
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
    print('==> ad ${ad.toJson()}');
    // await _apiConsumer.post(EndPoints.filterAd(ad), data:{
    //   "filterCriteria":{
    //     "678c8abd8bca9086d27b0b5f":{"type":"string", "value": "High School"}
    //   }
    // });
    try {
      return response.fold((failure) => Left(failure), (response) {
        print('Filter response structure: $response');

        // Check if response has the expected structure
        if (response['data'] == null) {
          print('Response data is null');
          return Left(UnknownFailure('Response data is null'));
        }

        // Try different possible response structures
        List<dynamic> adsList = [];

        // Check for response['data']['allAds']['ads'] structure
        if (response['data']['allAds'] != null &&
            response['data']['allAds']['ads'] != null) {
          adsList = response['data']['allAds']['ads'] as List;
        }
        // Check for response['data']['ads'] structure
        else if (response['data']['ads'] != null) {
          adsList = response['data']['ads'] as List;
        }
        // Check for response['data'] being a list directly
        else if (response['data'] is List) {
          adsList = response['data'] as List;
        }
        // Check for response['ads'] structure
        else if (response['ads'] != null) {
          adsList = response['ads'] as List;
        } else {
          print('No ads found in response structure');
          return Left(UnknownFailure('No ads found in response structure'));
        }

        return Right(adsList.map((e) => AdModel.fromJson(e)).toList());
      });
    } catch (e) {
      print('Error in filterAd: $e');
      return Left(UnknownFailure(e.toString()));
    }
  }
}
