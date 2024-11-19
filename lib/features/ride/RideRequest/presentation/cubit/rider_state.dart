import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/all_trip_for_driver_mode/all_trip_for_driver_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/check_accept_by_rider_model/check_accept_by_rider_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/check_accept_trip_from_driver_model/check_accept_trip_from_driver_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/get_trip_info_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/picture_optional_model/picture_optional_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/reasons_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/success_request_trip_model/success_request_trip_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/trip_request_offer_model/trip_request_offer_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/trip_response_model/trip_response_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/banner_model.dart';

class RiderState {}

class InitalRiderState extends RiderState {}

class SuccessGetCateogyRider extends RiderState {
  final BannerModel model;

  SuccessGetCateogyRider({required this.model});
}

class FailureRiderState extends RiderState {
  final Failure failure;

  FailureRiderState({required this.failure});
}

class RiderInitial extends RiderState {}

class SuccessRegisterRiderState extends RiderState {
  final String message;

  SuccessRegisterRiderState({required this.message});
}

class LoadingRiderState extends RiderState {}

class ViewPickTripDataState extends RiderState {}

class NotViewPickTripDataState extends RiderState {}

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