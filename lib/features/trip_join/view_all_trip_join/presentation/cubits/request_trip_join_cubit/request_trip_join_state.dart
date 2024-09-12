part of 'request_trip_join_cubit.dart';

sealed class RequestTripJoinState {}

final class RequestTripJoinInitial extends RequestTripJoinState {}

final class RequestTripJoinLoading extends RequestTripJoinState {}

final class RequestTripJoinFailed extends RequestTripJoinState {
  final String errorMessage;

  RequestTripJoinFailed(this.errorMessage);
}

final class RequestTripJoinSuccess extends RequestTripJoinState {}
