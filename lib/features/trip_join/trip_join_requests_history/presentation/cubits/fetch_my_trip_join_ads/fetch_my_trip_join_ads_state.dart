part of 'fetch_my_trip_join_ads_cubit.dart';

sealed class FetchMyTripJoinAdsState {}

final class FetchMyTripJoinAdsInitial extends FetchMyTripJoinAdsState {}

final class FetchMyTripJoinAdsLoading extends FetchMyTripJoinAdsState {}

final class FetchMyTripJoinAdsFailed extends FetchMyTripJoinAdsState {
  final String message;
  FetchMyTripJoinAdsFailed(this.message);
}

final class FetchMyTripJoinAdsSuccess extends FetchMyTripJoinAdsState {
  final List<TripJoinMyRequestEntity> trips;

  FetchMyTripJoinAdsSuccess(this.trips);
}
