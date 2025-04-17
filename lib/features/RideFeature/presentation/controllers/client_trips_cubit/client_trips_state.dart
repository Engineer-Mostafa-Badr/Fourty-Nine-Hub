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
  final List<CityEntity>? cities;
  final List<GovernorateEntity>? governorates;
  const ClientTripsState({
    this.status = ClientTripsStates.initState,
    this.failure,
    this.offers,
    this.cities,
    this.governorates,
  });
  ClientTripsState copyWith({
    ClientTripsStates? status,
    Failure? failure,
    List<TripEntity>? offers,
    List<CityEntity>? cities,
    List<GovernorateEntity>? governorates,
  }) {
    return ClientTripsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      offers: offers ?? this.offers,
      cities: cities ?? this.cities,
      governorates: governorates ?? this.governorates,
    );
  }
}
