part of 'dashboards_cubit.dart';

enum DashboardsStates {
  initState,
  loading,
  loadingModels,
  error,
  success,
}

extension DashboardsStatex on DashboardsState {
  bool get isInitial => status == DashboardsStates.initState;
  bool get isLoading => status == DashboardsStates.loading;
  bool get isLoadingModels => status == DashboardsStates.loadingModels;
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
  const DashboardsState(
      {this.failure,
      this.pastTrips,
      this.status = DashboardsStates.initState,
      this.availableTrips});
  DashboardsState copyWith(
      {DashboardsStates? status,
      Failure? failure,
      List<TripEntity>? pastTrips,
      List<TripEntity>? availableTrips}) {
    return DashboardsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      pastTrips: pastTrips ?? this.pastTrips,
      availableTrips: availableTrips ?? this.availableTrips,
    );
  }

  // @override
  // List<Object> get props => [status, failure!, availableTrips!];
}

// final class DashboardsInitial extends DashboardsState {
//   DashboardsInitial(super.status);
// }
