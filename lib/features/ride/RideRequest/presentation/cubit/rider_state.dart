import 'dart:io';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/requests_history/data/models/request_history_ride_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/all_trip_for_driver_mode/all_trip_for_driver_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/all_trip_no_socket_model/all_trip_no_socket_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/car_models_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/check_accept_by_rider_model/check_accept_by_rider_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/check_accept_trip_from_driver_model/check_accept_trip_from_driver_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/color_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/current_trip_ride_model/current_trip_ride_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/driver_info_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/driver_near_by_model/driver_near_by_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/get_trip_info_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/my_trip_offer_ride_model/my_trip_offer_ride_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/my_trip_ride_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/picture_optional_model/picture_optional_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/reasons_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/success_request_trip_model/success_request_trip_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/trip_request_offer_model/trip_request_offer_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/trip_response_model/trip_response_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/banner_model.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/data/models/car_brand_model.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/data/models/car_year_type_model.dart';

class RiderState {}

class InitalRiderState extends RiderState {}

class SuccessGetCateogyRider extends RiderState {
  final BannerModel model;
  List<SubCategoryEntity>? editedCategoryList;
  SuccessGetCateogyRider({required this.model, this.editedCategoryList});
}

class FailureRiderState extends RiderState {
  final Failure failure;

  FailureRiderState({required this.failure});
}

class SucccessHistoryRiderState extends RiderState {
  final List<RequestHistoryRideModel>? trips;

  SucccessHistoryRiderState({required this.trips});
}

class RiderInitial extends RiderState {}

class SuccessRegisterRiderState extends RiderState {
  final String message;

  SuccessRegisterRiderState({required this.message});
}

class LoadingRiderState extends RiderState {}

class ViewPickTripDataState extends RiderState {}

class NotViewPickTripDataState extends RiderState {}

class LoadingGetDriverStatus extends RiderState {}

class SuccessGetDriverStatus extends RiderState {
  final bool status;

  SuccessGetDriverStatus({required this.status});
}

class FailureGetDriverStatus extends RiderState {}

class SuccessGetTripInfoState extends RiderState {
  final GetTripInfoModel model;

  SuccessGetTripInfoState({required this.model});
}

class SuccessGetPictureOptionalState extends RiderState {
  final PictureOptionalModel value;

  SuccessGetPictureOptionalState({required this.value});
}

class SuccessRequestTripState extends RiderState {
  final SuccessRequestTripModel model;
  SuccessRequestTripState({required this.model});
}

class SuccessAcceptOfferRideState extends RiderState {
  final CheckAcceptTripFromDriverModel model;

  SuccessAcceptOfferRideState({required this.model});
}

class SuccessDclineOfferRideState extends RiderState {}

class SuccessGetOfferDataState extends RiderState {
  TripRequestOfferModel? data;
  SuccessGetOfferDataState({this.data});
}

class SuccessGetAllTripsRiderState extends RiderState {
  final List<AllTripForDriverModel> list;

  SuccessGetAllTripsRiderState({required this.list});
}

class SuccessGetExpairedTripRider extends RiderState {
  final List<TripResponseModel> list;

  SuccessGetExpairedTripRider({required this.list});
}

class SuccesCheckDriverTypeState extends RiderState {
  final bool shipping;
  final bool rider;

  SuccesCheckDriverTypeState({required this.shipping, required this.rider});
}

class SuccessSelectCateogryState extends RiderState {
  final String id;
  final int type;

  SuccessSelectCateogryState({required this.id, required this.type});
}

class SuccessCreateRequestTripRideState extends RiderState {}

class SuccessGetStartingPointState extends RiderState {
  final double lat;
  final double lng;
  final String address;
  final String type;

  SuccessGetStartingPointState(
      {required this.address,
      required this.lat,
      required this.lng,
      required this.type});
}

class SuccessGetDestinationPointState extends RiderState {
  final double lat;
  final double lng;
  final String address;
  final String type;

  SuccessGetDestinationPointState(
      {required this.address,
      required this.lat,
      required this.lng,
      required this.type});
}

class StartingLocationLoading extends RiderState {}

class DestintionLocationLoading extends RiderState {}

class StartingLocationFailed extends RiderState {}

class DestinationLocationFailed extends RiderState {}

class SuccessAcceptOfferByDriverState extends RiderState {
  final CheckAcceptByRiderModel model;

  SuccessAcceptOfferByDriverState({required this.model});
}

class SuccessSendOfferByDriverState extends RiderState {}

class SuccessCheckAcceptByRiderState extends RiderState {
  final CheckAcceptByRiderModel model;

  SuccessCheckAcceptByRiderState({required this.model});
}

class SuccessCheckAcceptByDriverState extends RiderState {
  final CheckAcceptTripFromDriverModel model;

  SuccessCheckAcceptByDriverState({required this.model});
}

class SuccessRiderInStartLocationState extends RiderState {}

class SuccessStartTripRiderState extends RiderState {}

class SuccessPartialPaymentState extends RiderState {}

class SuccessCompletedTripRiderState extends RiderState {}

class SuccessCancelTripClientState extends RiderState {}

class SuccessCancelTripRiderState extends RiderState {}

class SuccessGetResonsState extends RiderState {
  final List<ReasonsModel> list;

  SuccessGetResonsState({required this.list});
}

class CashPaymentState extends RiderState {}

class WalletPayemntState extends RiderState {}

class SuccessGetAllTripNoSocketState extends RiderState {
  final List<AllTripNoSocketModel> list;

  SuccessGetAllTripNoSocketState({required this.list});
}

class SuccessSendOfferNoSocketState extends RiderState {}

class SuccessAcceptOfferNoSocketState extends RiderState {}

class SuccessRejectOfferNoSocketState extends RiderState {}

class SuccessCompleteOfferNoSocketState extends RiderState {}

class SuccessDeleteTripNoSocketState extends RiderState {}

class SuccessGetUserLoginTripNoSocketState extends RiderState {
  final MyTripRideModel model;

  SuccessGetUserLoginTripNoSocketState({required this.model});
}

class SuccessGetAllOfferNoSocketState extends RiderState {
  final List<MyTripOfferRideModel> list;

  SuccessGetAllOfferNoSocketState({required this.list});
}

class SuccessRateDvierState extends RiderState {}

class SuccessCheckTripEndState extends RiderState {}

class SuccessStartRecordState extends RiderState {}

class SuccessStopRecordState extends RiderState {}

class SuccessGetDriverInfoState extends RiderState {
  final DriverInfoModel model;

  SuccessGetDriverInfoState({required this.model});
}

class SuccessDeleteDriverState extends RiderState {}

class SuccessGetDriversNearState extends RiderState {
  final List<DriverNearByModel> list;

  SuccessGetDriversNearState({required this.list});
}

class SuccessGetCurrentTripState extends RiderState {
  final CurrentTripRideModel model;

  SuccessGetCurrentTripState({required this.model});
}

class SuccessGetCarBrandRideState extends RiderState {
  final List<CarBrandModel> list;

  SuccessGetCarBrandRideState({required this.list});
}

class SuccessGetCarModelByBrandRideState extends RiderState {
  final List<CarModelsModel> list;

  SuccessGetCarModelByBrandRideState({required this.list});
}

class SuccessGetCarYearTypeRideState extends RiderState {
  final List<CarYearTypeModel> list;

  SuccessGetCarYearTypeRideState({required this.list});
}

class SuccessGetCarColorsRideState extends RiderState{
  final List<ColorModel> list;

  SuccessGetCarColorsRideState({required this.list});
}

class SuccessPickDriverImageState extends RiderState{
  final File image;

  SuccessPickDriverImageState({required this.image});
}