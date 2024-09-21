import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/get_trip_info_model/get_trip_info_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/picture_optional_model/picture_optional_model.dart';
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

class SuccessRequestTripState extends RiderState{}