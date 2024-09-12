part of 'notification_socket_io_cubit.dart';

sealed class NotificationSocketIoState {}

final class NotificationSocketIoInitial extends NotificationSocketIoState {}

final class NotificationSocketIoFailed extends NotificationSocketIoState {
  final String message;

  NotificationSocketIoFailed(this.message);
}

final class NotificationSocketIoNewNotification
    extends NotificationSocketIoState {
  final NotificationEntity notificationEntity;

  NotificationSocketIoNewNotification(this.notificationEntity);
}
