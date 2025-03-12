part of 'get_user_trips_notifications_cubit.dart';

sealed class GetUserTripsNotificationsState {}

final class GetUserTripsNotificationsInitial
    extends GetUserTripsNotificationsState {}

final class GetUserTripsNotificationsLoading
    extends GetUserTripsNotificationsState {}

final class GetUserTripsNotificationsFailed
    extends GetUserTripsNotificationsState {
  final String message;

  GetUserTripsNotificationsFailed(this.message);
}

final class GetUserTripsNotificationsSuccess
    extends GetUserTripsNotificationsState {
  final List<UserTripEntity> userTrips;

  GetUserTripsNotificationsSuccess(this.userTrips);
}
