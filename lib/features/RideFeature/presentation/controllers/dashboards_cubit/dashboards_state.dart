part of 'dashboards_cubit.dart';

enum DashboardsStates {
  initState,
  loading,
  loadingAcceptOffer,
  loadingAvailable,
  loadingAcceptTrip,
  loadingPast,
  loadingSettings,
  loadingCreateOffer,
  loadingRating,
  loadingModels,
  error,
  errorOffers,
  success,
  successAcceptTrip,
  successOffer,
  successRating,
}

extension DashboardsStatex on DashboardsState {
  bool get isInitial => status == DashboardsStates.initState;
  bool get isLoading => status == DashboardsStates.loading;
  bool get isLoadingAcceptTrip => status == DashboardsStates.loadingAcceptTrip;
  bool get isLoadingAcceptOffer => status == DashboardsStates.loadingAcceptOffer;
  bool get isLoadingModels => status == DashboardsStates.loadingModels;
  bool get isLoadingAvailable => status == DashboardsStates.loadingAvailable;
  bool get isLoadingPast => status == DashboardsStates.loadingPast;
  bool get isLoadingSettings => status == DashboardsStates.loadingSettings;
  bool get isLoadingCreateOffer => status == DashboardsStates.loadingCreateOffer;
  bool get isLoadingRating => status == DashboardsStates.loadingRating;
  bool get isError => status == DashboardsStates.error;
  bool get isErrorOffers => status == DashboardsStates.errorOffers;
  bool get isSuccess => status == DashboardsStates.success;
  bool get isSuccessOffer => status == DashboardsStates.successOffer;
  bool get isSuccessRating => status == DashboardsStates.successRating;
  bool get isSuccessAcceptTrip => status == DashboardsStates.successAcceptTrip;
}

class DashboardsState
// extends Equatable
{
  final DashboardsStates status;
  final Failure? failure;
  final List<TripEntity>? availableTrips;
  final List<TripEntity>? pastTrips;
  final SettingsDashboardEntity? settings;
  final List<AvailableRideTripEntity>? availableRideTrips;
  const DashboardsState(
      {this.failure,
      this.pastTrips,
      this.settings,
      this.status = DashboardsStates.initState,
      this.availableTrips,
      this.availableRideTrips,
      });
  DashboardsState copyWith(
      {DashboardsStates? status,
      Failure? failure,
      List<TripEntity>? pastTrips,
      List<TripEntity>? availableTrips,
      List<AvailableRideTripEntity>? availableRideTrips,
      SettingsDashboardEntity? settings,
      }) {
    return DashboardsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      pastTrips: pastTrips ?? this.pastTrips,
      settings: settings ?? this.settings,
      availableTrips: availableTrips ?? this.availableTrips,
      availableRideTrips: availableRideTrips ?? this.availableRideTrips,
    );
  }

  // @override
  // List<Object> get props => [status, failure!, availableTrips!];
}

// final class DashboardsInitial extends DashboardsState {
//   DashboardsInitial(super.status);
// }
