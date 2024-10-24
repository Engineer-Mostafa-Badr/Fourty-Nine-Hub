part of 'ad_requests_cubit.dart';

enum AdRequestsStates { loading, initState, error, success }

extension AdRequestsStateX on AdRequestsState {
  bool get isInitial => status == AdRequestsStates.initState;
  bool get isLoading => status == AdRequestsStates.loading;
  bool get isError => status == AdRequestsStates.error;
  bool get isSuccess => status == AdRequestsStates.success;
}

class AdRequestsState {
  final AdRequestsStates? status;
  final Failure? failure;
  final List<AdRequestEntity>? requests;
  const AdRequestsState({
    this.status,
    this.failure,
    this.requests,
  });
  AdRequestsState copyWith({
    AdRequestsStates? status,
    Failure? failure,
    List<AdRequestEntity>? requests,
  }) {
    return AdRequestsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      requests: requests ?? this.requests,
    );
  }
}
