part of 'ads_cubit.dart';

enum AdsStates { loading, initState, error, success }

extension AdsStateX on AdsState {
  bool get isInitial => status == AdsStates.initState;
  bool get isLoading => status == AdsStates.loading;
  bool get isError => status == AdsStates.error;
  bool get isSuccess => status == AdsStates.success;
}

@immutable
class AdsState {
  final Failure? failure;
  final AdsStates? status;
  final List<AdModel>? ads;
  final List<TripEntity>? comeWithMeAds;
  final List<TripEntity>? pickMeAds;
  const AdsState(
      {this.ads,
      this.failure,
      this.status,
      this.comeWithMeAds,
      this.pickMeAds});
  AdsState copyWith({
    Failure? failure,
    AdsStates? status,
    List<TripEntity>? comeWithMeAds,
    List<TripEntity>? pickMeAds,
    List<AdModel>? ads,
  }) {
    return AdsState(
        failure: failure ?? this.failure,
        status: status ?? this.status,
        ads: ads ?? this.ads,
        pickMeAds: pickMeAds ?? this.pickMeAds,
        comeWithMeAds: comeWithMeAds ?? this.comeWithMeAds);
  }
}
