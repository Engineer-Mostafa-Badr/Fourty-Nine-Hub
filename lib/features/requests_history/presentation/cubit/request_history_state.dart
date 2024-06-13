part of 'request_history_cubit.dart';

enum RequestHistoryStates { loading, initState, error }

extension RequestHistoryStateX on RequestHistoryState {
  bool get isLoading => status == RequestHistoryStates.loading;
  bool get isInitState => status == RequestHistoryStates.initState;
  bool get isError => status == RequestHistoryStates.error;
}

@immutable
class RequestHistoryState{
  final Failure? failure;
  final RequestHistoryStates? status;
  final List<TripModel>? trips;
  final List<FoodOrderModel>? foodOrders;

  const RequestHistoryState({
    this.status,
    this.trips,
    this.failure,
    this.foodOrders,
  });
  RequestHistoryState copyWith({
    RequestHistoryStates? status,
    List<TripModel>? trips,
    List<FoodOrderModel>? foodOrders,
    Failure? failure,
  }) {
    return RequestHistoryState(
        status: status ?? this.status,
        trips: trips ?? this.trips,
        foodOrders: foodOrders?? this.foodOrders,
        failure: failure ?? this.failure);
  }

  
}
