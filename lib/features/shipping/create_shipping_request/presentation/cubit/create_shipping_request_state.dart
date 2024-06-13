part of 'create_shipping_request_cubit.dart';

enum CreateShippingRequestStates { loading, error, initState }

extension CreateShippingRequestStateX on CreateShippingRequestState {
    bool get isInitial => status == CreateShippingRequestStates.initState;
    bool get isError => status == CreateShippingRequestStates.error;
    bool get isLoading => status == CreateShippingRequestStates.loading;

}

@immutable
class CreateShippingRequestState {
  final CreateShippingRequestStates status;
  final bool? isPaymentRequired;
  final List<SubCategoryModel>? subCategories;
  final SubCategoryModel? subCategory;
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

  bool get reqestIsReady =>
      fromAddress != null && toAddress != null && minimumPrice != null;

  const CreateShippingRequestState(
      {this.request,
      this.nearByPlaces = const [],
      this.isPaymentRequired = false,
      this.errorMessage,
      this.status = CreateShippingRequestStates.initState,
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
      this.subCategories,
      this.subCategory});

  CreateShippingRequestState copyWith({
    CreateShippingRequestStates? status,
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
    List<SubCategoryModel>? subCategories,
    SubCategoryModel? subCategory,
  }) {
    return CreateShippingRequestState(
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
      selectedCarTypes: selectedCarTypes ?? this.selectedCarTypes,
      failure: failure ?? this.failure,
      subCategory: subCategory ?? this.subCategory,
    );
  }
}
