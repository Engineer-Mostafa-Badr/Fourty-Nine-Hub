import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/requests_history/data/models/shipping_request_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/all_trip_model/all_trip_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/banner_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/get_requests_for_loading_model/get_requests_for_loading_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/trip_by_user_model.dart';

class ShippingState {}

class ShippingInitial extends ShippingState {}

class SuccessGetBannerState extends ShippingState {
  final BannerModel model;

  SuccessGetBannerState({required this.model});
}

class FailureShippingState extends ShippingState {
  final Failure failure;

  FailureShippingState({required this.failure});
}

class SucccessGetIdS3 extends ShippingState {
  // final IdS3ResponseModel model;

  // SucccessGetIdS3({required this.model});
}

class SuccessFavorite extends ShippingState {}

class SuccessCreateTrip extends ShippingState {
  final String message;

  SuccessCreateTrip({required this.message});
}

class FaliureState extends ShippingState {
  final String message;

  FaliureState({required this.message});
}

class SuccessRegisterState extends ShippingState {
  final String message;

  SuccessRegisterState({required this.message});
}

class SuccessGetAllTripState extends ShippingState {
  final List<AllTripModel> allTripList;

  SuccessGetAllTripState({required this.allTripList});
}

class SuccessAcceptOfferState extends ShippingState {
  final String message;

  SuccessAcceptOfferState({required this.message});
}

class SuccessSendNewOfferState extends ShippingState {
  final String message;

  SuccessSendNewOfferState({required this.message});
}

class SuccessAcceptPremiumOfferState extends ShippingState {
  final String message;

  SuccessAcceptPremiumOfferState({required this.message});
}

class LoadingShippingState extends ShippingState {}

class SuccessGetCallMessageState extends ShippingState {
  final bool data;

  SuccessGetCallMessageState({required this.data});
}

class SuccessReportState extends ShippingState {}

class SuccessGetMyTripState extends ShippingState {
  final TripByUserModel model;

  SuccessGetMyTripState({required this.model});
}

class SuccessGetLoadingTripRequests extends ShippingState {
  final List<GetRequestsForLoadingModel> request;

  SuccessGetLoadingTripRequests({required this.request});
}

class SuccessGetShippingHistoryState extends ShippingState {
  final List<ShippingRequestModel> list;

  SuccessGetShippingHistoryState({required this.list});
}
