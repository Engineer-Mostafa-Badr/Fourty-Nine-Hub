part of 'ads_cubit.dart';

enum AdsStates { loading, initState, error }

extension AdsStateX on AdsState {
    bool get isInitial => status == AdsStates.initState;
    bool get isLoading => status == AdsStates.loading;
    bool get isError => status == AdsStates.error;
}

@immutable
class AdsState {
  final Failure? failure;
  final AdsStates? status;
  final List<AdModel>? ads;
  const AdsState({this.ads, this.failure, this.status});
  AdsState copyWith({
    Failure? failure,
    AdsStates? status,
    List<AdModel>? ads,
  }) {
    return AdsState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      ads: ads ?? this.ads,
    );
  }
}
