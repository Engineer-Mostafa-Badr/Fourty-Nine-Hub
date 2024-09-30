part of 'delete_notification_cubit.dart';

sealed class DeleteNotificationState {}

final class DeleteNotificationInitial extends DeleteNotificationState {}

final class DeleteNotificationLoading extends DeleteNotificationState {}

final class DeleteNotificationFailed extends DeleteNotificationState {
  final String message;

  DeleteNotificationFailed(this.message);
}

final class DeleteNotificationSuccess extends DeleteNotificationState {}
