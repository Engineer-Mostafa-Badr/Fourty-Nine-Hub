part of 'publish_trip_join_cubit.dart';

sealed class PublishTripJoinState {}

final class PublishTripJoinInitial extends PublishTripJoinState {}

final class PublishTripJoinLoading extends PublishTripJoinState {}

final class PublishTripJoinFailed extends PublishTripJoinState {
  final String errorMessage;

  PublishTripJoinFailed(this.errorMessage);
}

final class PublishTripJoinSuccess extends PublishTripJoinState {}
