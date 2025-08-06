part of 'client_trips_cubit.dart';

enum ClientTripsStates {
  initState,
  loading,
  loadingAcceptOffer,
  loadingRating,
  loadingSubmit,
  loadingGovernorates,
  loadingCities,
  loadingOffers,
  error,
  errorCreateTrip,
  errorOffers,
  success,
  successCreateTrip,
  successGovernorates,
  successOffer,
  successRating,
}

extension ClientTripsStatex on ClientTripsState {
  bool get isInitial => status == ClientTripsStates.initState;
  bool get isLoading => status == ClientTripsStates.loading;
  bool get isLoadingSubmit => status == ClientTripsStates.loadingSubmit;
  bool get isLoadingGovernorates =>
      status == ClientTripsStates.loadingGovernorates;
  bool get isLoadingCities => status == ClientTripsStates.loadingCities;
  bool get isLoadingOffers => status == ClientTripsStates.loadingOffers;
  bool get isLoadingAcceptOffer =>
      status == ClientTripsStates.loadingAcceptOffer;
  bool get isLoadingRating => status == ClientTripsStates.loadingRating;
  bool get isError => status == ClientTripsStates.error;
  bool get isErrorCreateTrip => status == ClientTripsStates.errorCreateTrip;
  bool get isErrorOffers => status == ClientTripsStates.errorOffers;
  bool get isSuccess => status == ClientTripsStates.success;
  bool get isSuccessCreateTrip => status == ClientTripsStates.successCreateTrip;
  bool get isSuccessGovernorates =>
      status == ClientTripsStates.successGovernorates;
  bool get isSuccessOffer => status == ClientTripsStates.successOffer;
  bool get isSuccessRating => status == ClientTripsStates.successRating;
}

class ClientTripsState {
  final ClientTripsStates status;
  final Failure? failure;
  final List<TripEntity>? offers;
  final String? subCategoryId;
  final List<CityEntity>? cities;
  final List<GovernorateEntity>? governorates;
  final CreateNonTrackTripEntity? createNonTrackTripEntity;
  final List<ClientPendingTripEntity>? clientPendingTripData;
  final List<ClientAcceptedTripEntity>? clientAcceptedTripData;
  final List<ClientOfferTripEntity> clientOfferTripData;
  final List<ClientPastTripEntity>? clientPastTripData;
   int newOfferCount;
  final CreateLoadingTripEntity? createLoadingTripEntity;
  final String? message;
  final bool showSnackbar;
  final RateResponseEntity? rateResponseEntity;
  final DriverAllRatingEntity? driverAllRating;
  final ClientAllRatingEntity? clientAllRating;
   ClientTripsState({
    this.status = ClientTripsStates.initState,
    this.failure,
    this.offers,
    this.cities,
    this.governorates,
    this.createNonTrackTripEntity,
    this.createLoadingTripEntity,
    this.clientPendingTripData,
    this.message,
    this.showSnackbar = false,
    this.clientAcceptedTripData,
    this.clientOfferTripData  = const  [],
    this.clientPastTripData,
    this.rateResponseEntity,
    this.driverAllRating,
    this.clientAllRating,
    this.subCategoryId,
    this.newOfferCount =0 ,
  });
  ClientTripsState copyWith({
    ClientTripsStates? status,
    Failure? failure,
    String? message,
    String? subCategoryId,
    List<TripEntity>? offers,
    List<CityEntity>? cities,
    List<GovernorateEntity>? governorates,
    CreateNonTrackTripEntity? createNonTrackTripEntity,
    CreateLoadingTripEntity? createLoadingTripEntity,
    List<ClientPendingTripEntity>? clientPendingTripData,
    List<ClientAcceptedTripEntity>? clientAcceptedTripData,
    bool? showSnackbar,
    List<ClientOfferTripEntity>? clientOfferTripData,
    List<ClientPastTripEntity>? clientPastTripData,
    RateResponseEntity? rateResponseEntity,
    DriverAllRatingEntity? driverAllRating,
    ClientAllRatingEntity? clientAllRating,
    int? newOfferCount,
  }) {
    return ClientTripsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      offers: offers ?? this.offers,
      cities: cities ?? this.cities,
      governorates: governorates ?? this.governorates,
      createNonTrackTripEntity: createNonTrackTripEntity ?? this.createNonTrackTripEntity,
      clientPendingTripData: clientPendingTripData ?? this.clientPendingTripData,
      message: message ?? this.message,
      showSnackbar: showSnackbar ?? this.showSnackbar,
      clientAcceptedTripData: clientAcceptedTripData ?? this.clientAcceptedTripData,
      clientOfferTripData: clientOfferTripData ?? this.clientOfferTripData,
      clientPastTripData: clientPastTripData ?? this.clientPastTripData,
      createLoadingTripEntity: createLoadingTripEntity ?? this.createLoadingTripEntity,
      rateResponseEntity: rateResponseEntity ?? this.rateResponseEntity,
      driverAllRating: driverAllRating ?? this.driverAllRating,
      clientAllRating: clientAllRating ?? this.clientAllRating,
      newOfferCount: newOfferCount ?? this.newOfferCount,
      subCategoryId: subCategoryId ?? this.subCategoryId,
    );
  }
}
