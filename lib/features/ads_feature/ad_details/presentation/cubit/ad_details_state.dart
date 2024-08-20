part of 'ad_details_cubit.dart';

enum AdDetailsStates { loading, initState, error, success }

extension AdDetailsStateX on AdDetailsState {
  bool get isInitial => status == AdDetailsStates.initState;
  bool get isLoading => status == AdDetailsStates.loading;
  bool get isError => status == AdDetailsStates.error;
  bool get isSuccess => status == AdDetailsStates.success;
}

class AdDetailsState {
  final AdDetailsStates? status;
  final Failure? failure;
  final AdModel? ad;
  final List<AdModel>? relevantAds;
  const AdDetailsState({
    this.ad,
    this.status,
    this.failure,
    this.relevantAds,
  });
  AdDetailsState copyWith({
    AdDetailsStates? status,
    Failure? failure,
    AdModel? ad,
    List<AdModel>? relevantAds,
  }) {
    return AdDetailsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      relevantAds: relevantAds ?? this.relevantAds,
      ad: ad ?? this.ad,
    );
  }
}
