import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/address_search_params_model.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/driver_review_model.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/report_model.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/ride_offer_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/error/failure.dart';
import '../../../subcategories/data/models/sub_category_model.dart';
import '../../data/models/car_models_model.dart';
import '../../data/models/car_type_model.dart';
import '../../data/models/expected_price_model.dart';
import '../../data/models/google_search_results.dart';
import '../../data/models/params/expected_price_params.dart';
import '../../data/models/ride_request_model.dart';


abstract class RideRequestRepo {
  Future<Either<Failure, List<SubCategoryModel>>> getSubCategories({required String mainCategoryId});
  Future<Either<Failure, double>> getTripPrice(
      {required RideRequestModel request});
  Future<Either<Failure, List<CarModelsModel>>> getCarModels();
  Future<Either<Failure, List<GoogleSearchResultModel>>>
      searchGoogleSearchNearByPlaces(
          {required AddressSearchParamsModel params});
  Future<Either<Failure, RideRequestModel>> addNormalRequest(
      {required RideRequestModel request});
  Future<Either<Failure, RideRequestModel>> addPrimaryRequest(
      {required RideRequestModel request});
  Future<Either<Failure, bool>> cancelTrip({required int requestId});
  Future<Either<Failure, bool>> reportTheDriver(
      {required RideReportModel report});
  Future<Either<Failure, List<RideRequestModel>>> getCustomerRequests();
  Future<Either<Failure, List<RideOfferModel>>> getRideOffers();
  Future<Either<Failure, bool>> acceptRideOffer({required int offerId});
  Future<Either<Failure, bool>> rejectRideOffer();
  Future<Either<Failure, bool>> callTheDriver();
  Future<Either<Failure, LatLng>> findDriverOnTheMap({required int driverId});
  Future<Either<Failure, bool>> checkUpdatePaymentMethodAvailability();
  Future<Either<Failure, bool>> updatePaymentMethod(
      {required int paymentMethodId});
  Future<Either<Failure, bool>> rateTheDriver(
      {required DriverReviewModel review});
  Future<Either<Failure, ExpectedPriceModel>> getExpectedPrice(
      {required ExpectedPriceParams params});
  Future<Either<Failure, List<CarTypeModel>>> getCarTypes({required String subCategoryId});
}
