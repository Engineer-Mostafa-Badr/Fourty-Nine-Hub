part of 'driver_dashboard_cubit.dart';

enum DriverDashboardStates { loading, initState, error, success }

extension DriverDashboardStateX on DriverDashboardState {
  bool get isLoading => status == DriverDashboardStates.loading;
  bool get isInitState => status == DriverDashboardStates.initState;
  bool get isError => status == DriverDashboardStates.error;
  bool get isSuccess => status == DriverDashboardStates.success;
}

class DriverDashboardState {
  final Failure? failure;
  final DriverDashboardStates? status;
  final DriverStatisticsModel? statistics;
  final List<TripModel>? trips;
  final bool? connected;

  const DriverDashboardState({
    this.status = DriverDashboardStates.initState,
    this.failure,
    this.trips,
    this.statistics,
    this.connected,
  });

  DriverDashboardState copyWith({
    Failure? failure,
    DriverDashboardStates? status,
    DriverStatisticsModel? statistics,
    List<TripModel>? trips,
    bool connected = true,
  }) {
    return DriverDashboardState(
        failure: failure ?? this.failure,
        status: status ?? this.status,
        connected: connected ?? this.connected,
        statistics: statistics ?? this.statistics,
        trips: trips ?? this.trips);
  }
}
