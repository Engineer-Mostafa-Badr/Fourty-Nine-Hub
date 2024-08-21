part of 'trip_join_view_cubit.dart';

sealed class TripJoinViewState {
  const TripJoinViewState();
}

final class TripJoinViewInitial extends TripJoinViewState {}

final class TripJoinViewShowDateState extends TripJoinViewState {
  final bool showDate;

  const TripJoinViewShowDateState(this.showDate);
}
