part of 'history_ride_cubit.dart';

enum HistoryRideStates { loading, initState, error }

extension HistoryRideStateX on HistoryRideState {
  bool get isLoading => status == HistoryRideStates.loading;
  bool get isInitState => status == HistoryRideStates.initState;
  bool get isError => status == HistoryRideStates.error;
}

@immutable
class HistoryRideState extends Equatable {
  final Failure? failure;
  final HistoryRideStates? status;
  final List<TripModel>? trips;

  const HistoryRideState({
    this.status,
    this.trips,
    this.failure,
  });
  HistoryRideState copyWith({
    HistoryRideStates? status,
    List<TripModel>? trips,
    Failure? failure,
  }) {
    return HistoryRideState(
        status: status ?? this.status,
        trips: trips ?? this.trips,
        failure: failure ?? this.failure);
  }

  @override
  List<Object> get props => [];
}
