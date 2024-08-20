part of 'trip_details_cubit.dart';

enum TripDetailsStates { loading, initState, error }

extension TripDetailsStateX on TripDetailsState {
  bool get isLoading => status == TripDetailsStates.loading;
  bool get isInitState => status == TripDetailsStates.initState;
  bool get isError => status == TripDetailsStates.error;
}

@immutable
class TripDetailsState extends Equatable {
  final TripDetailsStates status;
  final Failure? failure;
  final TripModel? trip;
  final List<CancelReasonModel>? cancelReasons;

  const TripDetailsState(
      {this.failure,
      this.trip,
      this.status = TripDetailsStates.loading,
      this.cancelReasons});

  TripDetailsState copyWith({
    TripDetailsStates? status,
    Failure? failure,
    TripModel? trip,
    List<CancelReasonModel>? cancelReasons,
  }) {
    return TripDetailsState(
        status: status ?? this.status,
        failure: failure ?? this.failure,
        cancelReasons: cancelReasons ?? this.cancelReasons,
        trip: trip ?? this.trip);
  }

  @override
  List<Object> get props => [];
}

class TripDetailsInitial extends TripDetailsState {}
