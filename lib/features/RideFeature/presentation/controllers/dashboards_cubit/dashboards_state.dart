part of 'dashboards_cubit.dart';

enum DashboardsStates {
  initState,
  loading,
  loadingSubmitRequest,
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
  bool get isLoadingSubmitRequest => status == DashboardsStates.loadingSubmitRequest;
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
  final int? currentIndex;
  final List<AvailableRideTripEntity>? availableRideTrips;
  final String? tripStatus;
  final String? lastStatus;
  final RunningTripEntity? activeTrip;
  final bool? isChangedMindReason;
  final bool? isOtherReason;
  final bool? isClientNotShownReason;
  final List<AvailableRideNonSocketTripEntity>? availableRideNonSocketTrips;
  final List<AcceptedRideNonSocketTripEntity>? acceptedRideNonSocketTrips;
  final List<HistoryTripEntity >? pastRideNonSocketTrips;
  const DashboardsState(
      {this.failure,
      this.pastTrips,
      this.settings,
      this.currentIndex=0,
      this.status = DashboardsStates.initState,
      this.availableTrips,
      this.availableRideTrips,
      this.availableRideNonSocketTrips,
      this.acceptedRideNonSocketTrips,
      this.pastRideNonSocketTrips,
      this.tripStatus,
      this.lastStatus,
      this.activeTrip,
      this.isChangedMindReason=false,
      this.isOtherReason=false,
      this.isClientNotShownReason=false,
      });
  DashboardsState copyWith(
      {DashboardsStates? status,
      Failure? failure,
      List<TripEntity>? pastTrips,
      List<TripEntity>? availableTrips,
      List<AvailableRideTripEntity>? availableRideTrips,
      SettingsDashboardEntity? settings,
      int? currentIndex,
        String? tripStatus,
        String? lastStatus,
        RunningTripEntity? activeTrip,
        bool? isChangedMindReason,
        bool? isOtherReason,
        bool? isClientNotShownReason,

        List<AvailableRideNonSocketTripEntity>? availableRideNonSocketTrips,
        List<AcceptedRideNonSocketTripEntity>? acceptedRideNonSocketTrips,
        List<HistoryTripEntity >? pastRideNonSocketTrips,
      }) {
    return DashboardsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      pastTrips: pastTrips ?? this.pastTrips,
      settings: settings ?? this.settings,
      currentIndex: currentIndex ?? this.currentIndex,
      availableTrips: availableTrips ?? this.availableTrips,
      availableRideTrips: availableRideTrips ?? this.availableRideTrips,
      availableRideNonSocketTrips: availableRideNonSocketTrips ?? this.availableRideNonSocketTrips,
      acceptedRideNonSocketTrips: acceptedRideNonSocketTrips ?? this.acceptedRideNonSocketTrips,
      pastRideNonSocketTrips: pastRideNonSocketTrips ?? this.pastRideNonSocketTrips,
      activeTrip: activeTrip ?? this.activeTrip,
      tripStatus: tripStatus ?? this.tripStatus,
      lastStatus: lastStatus ?? this.lastStatus,
      isChangedMindReason: isChangedMindReason ?? this.isChangedMindReason,
      isOtherReason: isOtherReason ?? this.isOtherReason,
      isClientNotShownReason: isClientNotShownReason ?? this.isClientNotShownReason,
    );
  }

  // @override
  // List<Object> get props => [status, failure!, availableTrips!];
}

// final class DashboardsInitial extends DashboardsState {
//   DashboardsInitial(super.status);
// }
