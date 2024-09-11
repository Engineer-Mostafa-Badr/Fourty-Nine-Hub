part of 'view_all_trip_join_cubit.dart';

sealed class ViewAllTripJoinState {}

final class ViewAllTripJoinInitial extends ViewAllTripJoinState {}

final class ViewAllTripJoinLoading extends ViewAllTripJoinState {}

final class ViewAllTripJoinFailed extends ViewAllTripJoinState {
  final String message;

  ViewAllTripJoinFailed(this.message);
}

final class ViewAllTripJoinSuccess extends ViewAllTripJoinState {
  final List<TripJoinCardEntity> allCards;

  ViewAllTripJoinSuccess(this.allCards);
}
