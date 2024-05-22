part of 'riderequest_cubit.dart';

enum RideRequestStatusesEnum {
  initState,
  loading,
  error,
  isSubscriptionRequired,
  isNearByPlacesLoading,
  isNearByPlaceSelected,
  isFromAndToLocationSelected,
  isPaymentError,
  isRequestSent,
  isWaitingOfferAcceptance,
  isOfferAccepted,
  isWaitingDriver,
  isTripStarted
}

extension RiderequestStateX on RiderequestState {
  bool get isInitial => status == RideRequestStatusesEnum.initState;
  bool get loading => status == RideRequestStatusesEnum.loading;
  bool get error => status == RideRequestStatusesEnum.error;
  bool get isNearByPlacesLoading =>
      status == RideRequestStatusesEnum.isNearByPlacesLoading;
  bool get isNearByPlaceSelected =>
      status == RideRequestStatusesEnum.isNearByPlaceSelected;
  bool get isFromAndToLocationSelected =>
      status == RideRequestStatusesEnum.isFromAndToLocationSelected;
  bool get isPaymentError => status == RideRequestStatusesEnum.isPaymentError;
  bool get isRequestSent => status == RideRequestStatusesEnum.isRequestSent;
  bool get isWaitingOfferAcceptance =>
      status == RideRequestStatusesEnum.isWaitingOfferAcceptance;
  bool get isOfferAccepted => status == RideRequestStatusesEnum.isOfferAccepted;
  bool get isWaitingDriver => status == RideRequestStatusesEnum.isWaitingDriver;
  bool get isTripStarted => status == RideRequestStatusesEnum.isTripStarted;
}

@immutable
class RiderequestState{
  
  final RideRequestStatusesEnum status;
  final bool isPaymentRequired;
  final RideRequestModel? request;

  const RiderequestState(
      {this.request,
      this.isPaymentRequired = false,
      this.status = RideRequestStatusesEnum.initState});

  RiderequestState copyWith(
      {RideRequestStatusesEnum? status,
      bool? isPaymentRequired,
      RideRequestModel? request}) {
    return RiderequestState(
      status: status ?? this.status,
      isPaymentRequired: isPaymentRequired ?? this.isPaymentRequired,
      request: request ?? this.request,
    );
  }
}
