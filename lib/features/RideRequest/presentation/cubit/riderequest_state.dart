part of 'riderequest_cubit.dart';

enum RideRequestStatusesEnum {
  initState,
  loading,
  error,
  isSubscriptionRequired,
  isNearByPlacesLoading,
  isNearByPlacesLoaded,
  isCameraMoving,
  isNearByPlaceSelected,
  isFromAndToLocationSelected,
  isPaymentError,
  isRequestSent,
  isWaitingOfferAcceptance,
  isOfferAccepted,
  isWaitingDriver,
  isTripStarted,
  isAutoAcceptChanged,
  isAirConiditionedChanged,
  isTimeAndDistanceLoaded,
  isCarTypesLoading,
  isCarTypesLoaded,
  isCarTypesSelectionChanged,
  isRequestSentSuccessfully
}

extension RiderequestStateX on RiderequestState {
  bool get isInitial => status == RideRequestStatusesEnum.initState;
  bool get loading => status == RideRequestStatusesEnum.loading;
  bool get error => status == RideRequestStatusesEnum.error;
  bool get isNearByPlacesLoading =>
      status == RideRequestStatusesEnum.isNearByPlacesLoading;
  bool get isNearByPlacesLoaded =>
      status == RideRequestStatusesEnum.isNearByPlacesLoaded;

  bool get isNearByPlaceSelected =>
      status == RideRequestStatusesEnum.isNearByPlaceSelected;
  bool get isFromAndToLocationSelected =>
      status == RideRequestStatusesEnum.isFromAndToLocationSelected;
  bool get isPaymentError => status == RideRequestStatusesEnum.isPaymentError;
  bool get isCameraMoving => status == RideRequestStatusesEnum.isCameraMoving;
  bool get isRequestSent => status == RideRequestStatusesEnum.isRequestSent;
  bool get isWaitingOfferAcceptance =>
      status == RideRequestStatusesEnum.isWaitingOfferAcceptance;
  bool get isOfferAccepted => status == RideRequestStatusesEnum.isOfferAccepted;
  bool get isWaitingDriver => status == RideRequestStatusesEnum.isWaitingDriver;
  bool get isTripStarted => status == RideRequestStatusesEnum.isTripStarted;
  bool get isAutoAcceptChanged =>
      status == RideRequestStatusesEnum.isAutoAcceptChanged;
  bool get isAirConiditionedChanged =>
      status == RideRequestStatusesEnum.isAirConiditionedChanged;
  bool get isTimeAndDistanceLoaded =>
      status == RideRequestStatusesEnum.isTimeAndDistanceLoaded;
  bool get isCarTypesLoading =>
      status == RideRequestStatusesEnum.isCarTypesLoading;
  bool get isCarTypesLoaded =>
      status == RideRequestStatusesEnum.isCarTypesLoaded;
  bool get isCarTypesSelectionChanged =>
      status == RideRequestStatusesEnum.isCarTypesSelectionChanged;
  bool get isRequestSentSuccessfully =>
      status == RideRequestStatusesEnum.isRequestSentSuccessfully;
}

@immutable
class RiderequestState {
  final RideRequestStatusesEnum status;
  final bool? isPaymentRequired;

  final RideRequestModel? request;
  final AddressSearchParamsEntity? fromAddress;
  final AddressSearchParamsEntity? toAddress;
  final List<GoogleSearchResultModel> nearByPlaces;
  final String? errorMessage;
  final double? minimumPrice;
  final double? offerPrice;
  final String? distance;
  final String? time;
  final bool autoAccept;
  final bool isAirConditioned;
  final List<CarTypeModel>? carTypes;
  final List<CarTypeModel>? selectedCarTypes;
  final Failure? failure;

  const RiderequestState({
    this.request,
    this.nearByPlaces = const [],
    this.isPaymentRequired = false,
    this.errorMessage,
    this.status = RideRequestStatusesEnum.initState,
    this.fromAddress,
    this.toAddress,
    this.minimumPrice = 0,
    this.offerPrice = 0,
    this.autoAccept = false,
    this.isAirConditioned = false,
    this.time,
    this.distance,
    this.selectedCarTypes,
    this.carTypes,
    this.failure,
  });

  RiderequestState copyWith({
    RideRequestStatusesEnum? status,
    bool? isPaymentRequired,
    List<GoogleSearchResultModel>? nearByPlaces,
    String? errorMessage,
    AddressSearchParamsEntity? fromAddress,
    AddressSearchParamsEntity? toAddress,
    RideRequestModel? request,
    double? minimumPrice,
    double? offerPrice,
    String? distance,
    String? time,
    bool? autoAccept,
    bool? isAirConditioned,
    List<CarTypeModel>? carTypes,
    List<CarTypeModel>? selectedCarTypes,
    Failure? failure,
  }) {
    return RiderequestState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isPaymentRequired: isPaymentRequired ?? this.isPaymentRequired,
      request: request ?? this.request,
      fromAddress: fromAddress ?? this.fromAddress,
      toAddress: toAddress ?? this.toAddress,
      nearByPlaces: nearByPlaces ?? this.nearByPlaces,
      minimumPrice: minimumPrice ?? this.minimumPrice,
      offerPrice: offerPrice ?? this.offerPrice,
      distance: distance ?? this.distance,
      time: time ?? this.time,
      autoAccept: autoAccept ?? this.autoAccept,
      isAirConditioned: isAirConditioned ?? this.isAirConditioned,
      carTypes: carTypes ?? this.carTypes,
      selectedCarTypes: selectedCarTypes ?? this.selectedCarTypes,
      failure: failure ?? this.failure,
    );
  }
}
