part of 'get_request_cubit.dart';

sealed class GetRequestState {}

final class GetRequestInitial extends GetRequestState {}

final class GetRequestLoading extends GetRequestState {}

final class GetRequestFailed extends GetRequestState {
  final String message;

  GetRequestFailed(this.message);
}

final class GetRequestSuccess extends GetRequestState {
  final List<TripJoinRequestHistoryEntity> requests;

  GetRequestSuccess(this.requests);
}
