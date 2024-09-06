part of 'get_services_notifications_cubit.dart';

sealed class GetServicesNotificationsState {}

final class GetServicesNotificationsInitial extends GetServicesNotificationsState {}

final class GetServicesNotificationsLoading extends GetServicesNotificationsState {}

final class GetServicesNotificationsFailed extends GetServicesNotificationsState {
  final String message;

  GetServicesNotificationsFailed(this.message);
}

final class GetServicesNotificationsSuccess extends GetServicesNotificationsState {
  final List<NotificationEntity> notifications;

  GetServicesNotificationsSuccess(this.notifications);
}
