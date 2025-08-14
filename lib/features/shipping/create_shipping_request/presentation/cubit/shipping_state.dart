import '../../../../../core/error/failure.dart';
import '../../../../requests_history/data/models/shipping_request_model/shipping_request_model.dart';
import '../../data/models/all_trip_model/all_trip_model.dart';
import '../../data/models/banner_model/banner_model.dart';
import '../../data/models/driver_statistice_model.dart';
import '../../data/models/get_driver_data_model/get_driver_data_model.dart';
import '../../data/models/get_requests_for_loading_model/get_requests_for_loading_model.dart';
import '../../data/models/trip_by_user_model.dart';
import '../../../../subcategories/domain/entities/sub_category_entity.dart';

class ShippingState {}

class ShippingInitial extends ShippingState {}

class SuccessGetBannerState extends ShippingState {
  final BannerModel model;
  List<SubCategoryEntity>? editedCategoryList;

  SuccessGetBannerState({required this.model, this.editedCategoryList});
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

class SuccessAcceptState extends ShippingState {}

class SuccessCancelState extends ShippingState {}

class SuccessDeclineState extends ShippingState {}

class SuccessGetDriverDataState extends ShippingState {
  final GetDriverDataModel model;

  SuccessGetDriverDataState({required this.model});
}

class SuccessUpdateDriverState extends ShippingState {}

class SuccessCompleteTripState extends ShippingState {}

class SuccessGetDriverStatisticsState extends ShippingState {
  final DriverStatisticeModel model;

  SuccessGetDriverStatisticsState({required this.model});
}

class SuccessDeleteDriver extends ShippingState {
  final String message;

  SuccessDeleteDriver({required this.message});
}

// class Delete
