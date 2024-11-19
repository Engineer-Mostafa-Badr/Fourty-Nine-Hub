part of 'fetch_my_pick_me_trips_cubit.dart';

sealed class FetchMyPickMeTripsState {}

final class FetchMyPickMeTripsInitial extends FetchMyPickMeTripsState {}

final class FetchMyPickMeTripsLoading extends FetchMyPickMeTripsState {}

final class FetchMyPickMeTripsSuccess extends FetchMyPickMeTripsState {
  final List<TripData> trips;

  FetchMyPickMeTripsSuccess({required this.trips});
}

final class FetchMyPickMeTripsFailure extends FetchMyPickMeTripsState {
  final String errorMessage;

  FetchMyPickMeTripsFailure({required this.errorMessage});
}
