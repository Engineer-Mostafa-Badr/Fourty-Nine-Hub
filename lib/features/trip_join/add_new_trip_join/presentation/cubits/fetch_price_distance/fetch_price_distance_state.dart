part of 'fetch_price_distance_cubit.dart';

sealed class FetchPriceDistanceState {}

final class FetchPriceDistanceInitial extends FetchPriceDistanceState {}

final class FetchPriceDistanceLoading extends FetchPriceDistanceState {}

final class FetchPriceDistanceFaild extends FetchPriceDistanceState {
  final String errorMessage;

  FetchPriceDistanceFaild({required this.errorMessage});
}

final class FetchPriceDistanceSuccess extends FetchPriceDistanceState {
  final TripInfoEntity tripInfoEntity;

  FetchPriceDistanceSuccess({required this.tripInfoEntity});
}
