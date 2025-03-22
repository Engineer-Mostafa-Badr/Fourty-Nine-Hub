part of 'dashboards_cubit.dart';

enum DashboardsStates {
  initState,
  loadingAvailable,
  loadingPast,
  loadingSettings,
  error,
  success,
}

extension DashboardsStatex on DashboardsState {
  bool get isInitial => status == DashboardsStates.initState;
  bool get isLoadingAvailable => status == DashboardsStates.loadingAvailable;
  bool get isLoadingPast => status == DashboardsStates.loadingPast;
  bool get isLoadingSettings => status == DashboardsStates.loadingSettings;
  bool get isError => status == DashboardsStates.error;
  bool get isSuccess => status == DashboardsStates.success;
}

class DashboardsState
// extends Equatable
{
  final DashboardsStates status;
  final Failure? failure;
  final List<TripEntity>? availableTrips;
  final List<TripEntity>? pastTrips;
  final SettingsDashboardEntity? settings;
  const DashboardsState(
      {this.failure,
      this.pastTrips,
      this.settings,
      this.status = DashboardsStates.initState,
      this.availableTrips});
  DashboardsState copyWith(
      {DashboardsStates? status,
      Failure? failure,
      List<TripEntity>? pastTrips,
      SettingsDashboardEntity? settings,
      List<TripEntity>? availableTrips}) {
    return DashboardsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      pastTrips: pastTrips ?? this.pastTrips,
      settings: settings ?? this.settings,
      availableTrips: availableTrips ?? this.availableTrips,
    );
  }

  // @override
  // List<Object> get props => [status, failure!, availableTrips!];
}

// final class DashboardsInitial extends DashboardsState {
//   DashboardsInitial(super.status);
// }
