import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/address_search_params_model.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/car_models_model.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/expected_price_model.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/google_search_results.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/params/expected_price_params.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/ride_offer_model.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/ride_request_model.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/sub_category_model.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/api/api_consumer.dart';
import '../../../../core/error/failure.dart';
import '../models/car_type_model.dart';
import '../models/driver_review_model.dart';
import '../models/report_model.dart';

abstract class RideRemoteDataSource {
  Future<Either<Failure, SubCategoryModel>> getSubCategories();

  Future<Either<Failure, double>> getTripPrice(
      {required RideRequestModel request});

  Future<Either<Failure, List<CarModelsModel>>> getCarModels();

  Future<Either<Failure, List<GoogleSearchResultModel>>> getNearByPlaces(
      {required AddressSearchParamsModel params});
  Future<Either<Failure, bool>> reportTheDriver(
      {required RideReportModel report});
  Future<Either<Failure, RideRequestModel>> addRideRequest(
      {required RideRequestModel request});

  Future<Either<Failure, List<RideRequestModel>>> getRideRequests();

  Future<Either<Failure, RideRequestModel>> getRideRequestDetails(
      {required int id});

  Future<Either<Failure, bool>> cancelRequest({required int requestId});

  Future<Either<Failure, bool>> acceptOffer({required int offerId});

  Future<Either<Failure, bool>> sendClientOffer();

  Future<Either<Failure, List<RideOfferModel>>> getOffers();

  Future<Either<Failure, LatLng>> getDriverLocation({required int driverId});

  Future<Either<Failure, bool>> updatePaymentMethod(
      {required int paymentMethodId});

  Future<Either<Failure, bool>> rateTheDriver(
      {required DriverReviewModel review});

  Future<Either<Failure, ExpectedPriceModel>> getExpectedPrice(
      {required ExpectedPriceParams params});
  Future<Either<Failure, List<CarTypeModel>>> getCarTypes({
    required String subCategoryId,
  });
}

class RideRemoteDataSourceImpl implements RideRemoteDataSource {
  final ApiConsumer _apiConsumer;

  const RideRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, bool>> acceptOffer({required int offerId}) {
    // TODO: implement acceptOffer
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, RideRequestModel>> addRideRequest(
      {required RideRequestModel request}) {
    // TODO: implement addRideRequest
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> cancelRequest({required int requestId}) {
    // TODO: implement cancelRequest
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, LatLng>> getDriverLocation({required int driverId}) {
    // TODO: implement getDriverLocation
    throw UnimplementedError();
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
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<RideOfferModel>>> getOffers() {
    // TODO: implement getOffers
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, RideRequestModel>> getRideRequestDetails(
      {required int id}) {
    // TODO: implement getRideRequestDetails
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<RideRequestModel>>> getRideRequests() {
    // TODO: implement getRideRequests
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> sendClientOffer() {
    // TODO: implement sendClientOffer
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, SubCategoryModel>> getSubCategories() {
    // TODO: implement getSubCategories
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, double>> getTripPrice(
      {required RideRequestModel request}) {
    // TODO: implement getTripPrice
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<CarModelsModel>>> getCarModels() {
    // TODO: implement getCarModels
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> updatePaymentMethod(
      {required int paymentMethodId}) {
    // TODO: implement updatePaymentMethod
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> reportTheDriver(
      {required RideReportModel report}) {
    // TODO: implement reportTheDriver
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> rateTheDriver(
      {required DriverReviewModel review}) {
    // TODO: implement rateTheDriver
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ExpectedPriceModel>> getExpectedPrice(
      {required ExpectedPriceParams params}) async {
    final response =
        await _apiConsumer.post(EndPoints.expectedPrice, data: params.toJson());
    return response.fold((failure) => Left(failure),
        (data) => Right(ExpectedPriceModel.fromJson(data['data'])));
  }

  @override
  Future<Either<Failure, List<CarTypeModel>>> getCarTypes({
    required String subCategoryId,
    int page = 1,
    int limit = 1,
  }) async {
    final response = await _apiConsumer.get(EndPoints.carTypes,
        queryParameters: {
          "subCategoryId": subCategoryId,
          "page": page,
          "limit": limit
        });
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['cars'] as List)
            .map((e) => CarTypeModel.fromJson(e))
            .toList()));
  }
}
