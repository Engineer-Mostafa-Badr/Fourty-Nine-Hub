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
  final AddDetailsModel? ad;
  final List<AdModel>? relevantAds;
  const AdRequestsState({
    this.ad,
    this.status,
    this.failure,
    this.relevantAds,
  });
  AdRequestsState copyWith({
    AdRequestsStates? status,
    Failure? failure,
    AddDetailsModel? ad,
    List<AdModel>? relevantAds,
  }) {
    return AdRequestsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      relevantAds: relevantAds ?? this.relevantAds,
      ad: ad ?? this.ad,
    );
  }
}
