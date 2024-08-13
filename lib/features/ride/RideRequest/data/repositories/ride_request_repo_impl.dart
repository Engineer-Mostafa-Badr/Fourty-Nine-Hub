import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/address_search_params_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/car_models_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/car_type_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/driver_review_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/expected_price_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/google_search_results.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/params/expected_price_params.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/report_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/ride_offer_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/ride_request_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/entity/ride_thumbnail_entity.dart';

import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/ride_request_repo.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

import '../../../../../core/error/failure.dart';
import '../../../../subcategories/data/models/sub_category_model.dart';
import '../datasources/remote_data_source.dart';

class RideRequestRepoImpl implements RideRequestRepo {
  RideRemoteDataSource _remoteDataSource;
  RideRequestRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, bool>> acceptRideOffer({required int offerId}) {
    return _remoteDataSource.acceptOffer(offerId: offerId);
  }

  @override
  Future<Either<Failure, String>> addNormalRequest(
      {required RideRequestModel request}) {
    return _remoteDataSource.addRideRequest(request: request);
  }

 

  @override
  Future<Either<Failure, bool>> callTheDriver() {
    // TODO: implement callTheDriver
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> cancelTrip({required int requestId}) {
    return _remoteDataSource.cancelRequest(requestId: requestId);
  }

  @override
  Future<Either<Failure, LatLng>> findDriverOnTheMap({required int driverId}) {
    return _remoteDataSource.getDriverLocation(driverId: driverId);
  }

  @override
  Future<Either<Failure, List<RideRequestModel>>> getCustomerRequests() {
    return _remoteDataSource.getRideRequests();
  }

  @override
  Future<Either<Failure, List<RideOfferModel>>> getRideOffers() {
    return _remoteDataSource.getOffers();
  }

  @override
  Future<Either<Failure, bool>> rejectRideOffer() {
    // TODO: implement rejectRideOffer
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> reportTheDriver(
      {required RideReportModel report}) {
    return _remoteDataSource.reportTheDriver(report: report);
  }

  @override
  Future<Either<Failure, List<GoogleSearchResultModel>>>
      searchGoogleSearchNearByPlaces(
          {required AddressSearchParamsModel params}) {
    return _remoteDataSource.getNearByPlaces(params: params);
  }

  @override
  Future<Either<Failure, bool>> checkUpdatePaymentMethodAvailability() {
    // TODO: implement checkUpdatePaymentMethodAvailability
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> updatePaymentMethod(
      {required int paymentMethodId}) {
    return _remoteDataSource.updatePaymentMethod(
        paymentMethodId: paymentMethodId);
  }

  @override
  Future<Either<Failure, List<CarModelsModel>>> getCarModels() {
    return _remoteDataSource.getCarModels();
  }

  @override
  Future<Either<Failure, List<SubCategoryModel>>> getSubCategories({required String mainCategoryId}) {
    return _remoteDataSource.getSubCategories(mainCategoryId: mainCategoryId);
  }

  @override
  Future<Either<Failure, double>> getTripPrice(
      {required RideRequestModel request}) {
    return _remoteDataSource.getTripPrice(request: request);
  }

  @override
  Future<Either<Failure, bool>> rateTheDriver(
      {required ReviewModel review}) {
    return _remoteDataSource.rateTheDriver(review: review);
  }

  @override
  Future<Either<Failure, ExpectedPriceModel>> getExpectedPrice(
      {required ExpectedPriceParams params}) {
    return _remoteDataSource.getExpectedPrice(params: params);
  }

  @override
  Future<Either<Failure, List<CarTypeModel>>> getCarTypes(
      {required String subCategoryId}) {
    return _remoteDataSource.getCarTypes(subCategoryId: subCategoryId);
  }

  @override
  Future<Either<Failure, List<RideThumbnailEntity>>> getThumbnails() {
    return _remoteDataSource.getThumbnails();
  }
}
