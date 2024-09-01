import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/data/datasources/json_parser.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../res/assets/jsons.dart';
import '../../../../../res/style/const.dart';
import '../../../../ride/RideRequest/data/models/address_search_params_model.dart';
import '../../../../ride/RideRequest/data/models/expected_price_model.dart';
import '../../../../ride/RideRequest/data/models/google_search_results.dart';
import '../../../../ride/RideRequest/data/models/params/expected_price_params.dart';
import '../../../../ride/RideRequest/data/models/ride_request_model.dart';
import '../../../../subcategories/data/models/sub_category_model.dart';

abstract class CreateShippingRemoteDataSource {
  Future<Either<Failure, List<SubCategoryModel>>> getSubCategories(
      {required String mainCategoryId});

  Future<Either<Failure, List<GoogleSearchResultModel>>> getNearByPlaces(
      {required AddressSearchParamsModel params});

  Future<Either<Failure, RideRequestModel>> addShippingRequest(
      {required RideRequestModel request});

  Future<Either<Failure, ExpectedPriceModel>> getExpectedPrice(
      {required ExpectedPriceParams params});
}

class CreateShippingRemoteDataSourceImpl
    implements CreateShippingRemoteDataSource {
  final JsonParser _apiConsumer;

  const CreateShippingRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, RideRequestModel>> addShippingRequest(
      {required RideRequestModel request}) {
    // TODO: implement addShippingRequest
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ExpectedPriceModel>> getExpectedPrice(
      {required ExpectedPriceParams params}) async {
    final response = await _apiConsumer.get(Jsons.exptectedPrice,
        queryParameters: params.toJson());
    return response.fold((failure) => Left(failure),
        (data) => Right(ExpectedPriceModel.fromJson(data['data'])));
  }

  @override
  Future<Either<Failure, List<GoogleSearchResultModel>>> getNearByPlaces(
      {required AddressSearchParamsModel params}) async {
    try {
      List<GoogleSearchResultModel> list = [];
      String mapKey = UIConst.googleMapAPIKey;
      final dioRequest = Dio(BaseOptions(
          baseUrl: 'https://maps.googleapis.com/maps/api/place/textsearch',
          followRedirects: false));

      final result =
          await dioRequest.get('/json?query=${params.address}&key=$mapKey');
      list = (result.data['results'] as List)
          .map((e) =>
              GoogleSearchResultModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return Right(list);
    } catch (e) {
      return  Left(UnknownFailure(''));
    }
  }

  @override
  Future<Either<Failure, List<SubCategoryModel>>> getSubCategories(
      {required String mainCategoryId}) async {
    final response = await _apiConsumer.get(Jsons.shippingSubCategories);

    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['sub_categories'] as List)
            .map((e) => SubCategoryModel.fromJson(e))
            .toList()));
  }
}
