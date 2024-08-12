part of 'riderequest_cubit.dart';

enum RideRequestStatusesEnum {
  initState,
  loading,
  error,
  success,
  requestSent
  
}

extension RiderequestStateX on RiderequestState {
  bool get isInitial => status == RideRequestStatusesEnum.initState;
  bool get loading => status == RideRequestStatusesEnum.loading;
  bool get error => status == RideRequestStatusesEnum.error;
  bool get isSuccess => status == RideRequestStatusesEnum.success;
  bool get isRequestSent => status == RideRequestStatusesEnum.requestSent;
}

class RiderequestState {
  final RideRequestStatusesEnum status;
  final bool? isPaymentRequired;
  final List<SubCategoryEntity>? subCategories;
  final SubCategoryEntity? subCategory;
  final RideRequestModel? request;
  final AddressSearchParamsEntity? fromAddress;
  final AddressSearchParamsEntity? toAddress;
  final List<GoogleSearchResultModel> nearByPlaces;
  final String? errorMessage;
  final double? minimumPrice;
  final double? offerPrice;
  final num? distance;
  final String? phone;
  final num? time;
  final int? passengers;
  final bool autoAccept;
  final bool isAirConditioned;
  final List<CarTypeModel>? carTypes;
  final List<CarTypeModel>? selectedCarTypes;
  final Failure? failure;

  bool get reqestIsReady =>
      fromAddress != null && toAddress != null && minimumPrice != null;

  const RiderequestState(
      {this.request,
      this.nearByPlaces = const [],
      this.isPaymentRequired = false,
      this.errorMessage,
      this.status = RideRequestStatusesEnum.initState,
      this.fromAddress,
      this.toAddress,
      this.minimumPrice = 0,
      this.offerPrice = 0,
      this.passengers = 1,
      this.autoAccept = false,
      this.isAirConditioned = false,
      this.phone,
      this.time,
      this.distance,
      this.selectedCarTypes,
      this.carTypes,
      this.failure,
      this.subCategories,
      this.subCategory});

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
    num? distance,
    num? time,
    bool? autoAccept,
    bool? isAirConditioned,
    List<CarTypeModel>? carTypes,
    List<CarTypeModel>? selectedCarTypes,
    Failure? failure,
    String? phone,
    int? passengers,
    List<SubCategoryEntity>? subCategories,
    SubCategoryEntity? subCategory,
  }) {
    return RiderequestState(
      subCategories: subCategories ?? this.subCategories,
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
      phone: phone ?? this.phone,
      selectedCarTypes: selectedCarTypes ?? this.selectedCarTypes,
      failure: failure ?? this.failure,
      subCategory: subCategory ?? this.subCategory,
      passengers: passengers ?? this.passengers,
    );
  }
}
