part of 'ads_cubit.dart';

enum AdsStates {
  loading,
  filterLoading,
  initState,
  error,
  success,
  requestSuccess,
  requestLoading
}

extension AdsStateX on AdsState {
  bool get isInitial => status == AdsStates.initState;
  bool get isLoading => status == AdsStates.loading;
  bool get isFilterLoading => status == AdsStates.filterLoading;
  bool get isError => status == AdsStates.error;
  bool get isSuccess => status == AdsStates.success;
  bool get isRequestSuccess => status == AdsStates.requestSuccess;
  bool get isRequestLoading => status == AdsStates.requestLoading;
}

@immutable
class AdsState {
  final Failure? failure;
  final AdsStates? status;
  final List<AdModel>? ads;
  final List<TripEntity>? comeWithMeAds;
  final List<TripEntity>? pickMeAds;
  final FilterModel? filterModel;
  final bool? hasFilter;
  String? city;
  String? governorate;
  final bool? makeRequest;
  AdsState(
      {this.ads,
      this.failure,
      this.status,
      this.city = '',
      this.governorate = '',
      this.filterModel,
      this.hasFilter = false,
      this.makeRequest = false,
      this.comeWithMeAds,
      this.pickMeAds});
  AdsState copyWith({
    Failure? failure,
    AdsStates? status,
    List<TripEntity>? comeWithMeAds,
    List<TripEntity>? pickMeAds,
    bool? hasFilter,
    bool? makeRequest,
    String? city,
    String? governorate,
    FilterModel? filterModel,
    List<AdModel>? ads,
  }) {
    return AdsState(
        failure: failure ?? this.failure,
        status: status ?? this.status,
        ads: ads ?? this.ads,
        city: city ?? this.city,
        governorate: governorate ?? this.governorate,
        hasFilter: hasFilter ?? this.hasFilter,
        pickMeAds: pickMeAds ?? this.pickMeAds,
        filterModel: filterModel ?? this.filterModel,
        makeRequest: makeRequest ?? this.makeRequest,
        comeWithMeAds: comeWithMeAds ?? this.comeWithMeAds);
  }
}
