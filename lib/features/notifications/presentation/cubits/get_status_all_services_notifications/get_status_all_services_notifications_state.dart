part of 'get_status_all_services_notifications_cubit.dart';

sealed class GetStatusAllServicesNotificationsState {}

final class GetUserTripsNotificationsInitial
    extends GetStatusAllServicesNotificationsState {}

final class GetUserTripsNotificationsLoading
    extends GetStatusAllServicesNotificationsState {}

final class GetUserTripsNotificationsFailed
    extends GetStatusAllServicesNotificationsState {
  final String message;

  GetUserTripsNotificationsFailed(this.message);
}

final class GetUserTripsNotificationsSuccess
    extends GetStatusAllServicesNotificationsState {
  final StatusAllServicesEntity statusAllServicesEntity;

  GetUserTripsNotificationsSuccess(this.statusAllServicesEntity);
}
