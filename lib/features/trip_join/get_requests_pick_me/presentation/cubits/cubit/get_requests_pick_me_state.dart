part of 'get_requests_pick_me_cubit.dart';

sealed class GetRequestsPickMeState {}

final class GetRequestsPickMeInitial extends GetRequestsPickMeState {}

final class GetRequestsPickMeLoading extends GetRequestsPickMeState {}

final class GetRequestsPickMeSuccess extends GetRequestsPickMeState {
  final List<TripDataWithRequests> tripDataWithRequests;
  GetRequestsPickMeSuccess({required this.tripDataWithRequests});
}

final class GetRequestsPickMeFailure extends GetRequestsPickMeState {
  final String errorMessage;

  GetRequestsPickMeFailure({required this.errorMessage});
}
