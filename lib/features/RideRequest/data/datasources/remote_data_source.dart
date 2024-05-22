import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/address_search_params_model.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/car_models_model.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/google_search_results.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/ride_offer_model.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/ride_request_model.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/sub_category_model.dart';
import 'package:fourtyninehub/features/RideRequest/domain/entity/address_search_params_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/error/failure.dart';
import '../models/driver_review_model.dart';
import '../models/report_model.dart';

abstract class RideRemoteDataSource {
  Future<Either<Failure, SubCategoryModel>> getSubCategories();
  
  Future<Either<Failure, double>> getTripPrice(
      {required RideRequestModel request});
  
  Future<Either<Failure, List<CarModelsModel>>> getCarModels();

  Future<Either<Failure, List<GoogleSearchResultModel>>> getNearByPlaces({
    required AddressSearchParamsModel params
  });
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

  Future<Either<Failure, bool>> updatePaymentMethod({required int paymentMethodId});

    Future<Either<Failure, bool>> rateTheDriver(
      {required DriverReviewModel review});
}

class RideRemoteDataSourceImpl implements RideRemoteDataSource {
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
      {required AddressSearchParamsModel params}) {
    // TODO: implement getNearByPlaces
    throw UnimplementedError();
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
  Future<Either<Failure, bool>> updatePaymentMethod({required int paymentMethodId}) {
    // TODO: implement updatePaymentMethod
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, bool>> reportTheDriver({required RideReportModel report}) {
    // TODO: implement reportTheDriver
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, bool>> rateTheDriver({required DriverReviewModel review}) {
    // TODO: implement rateTheDriver
    throw UnimplementedError();
  }
}
