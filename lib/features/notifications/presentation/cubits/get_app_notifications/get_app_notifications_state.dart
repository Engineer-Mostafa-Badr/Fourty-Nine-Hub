part of 'get_app_notifications_cubit.dart';

sealed class GetAppNotificationsState {}

final class GetAppNotificationsInitial extends GetAppNotificationsState {}

final class GetAppNotificationsLoading extends GetAppNotificationsState {}

final class GetAppNotificationsFailed extends GetAppNotificationsState {
  final String message;

  GetAppNotificationsFailed(this.message);
}

final class GetAppNotificationsSuccess extends GetAppNotificationsState {
  final List<NotificationEntity> notifications;

  GetAppNotificationsSuccess(this.notifications);
}
