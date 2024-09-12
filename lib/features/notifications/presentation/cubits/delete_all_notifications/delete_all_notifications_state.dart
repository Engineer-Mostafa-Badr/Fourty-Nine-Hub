part of 'delete_all_notifications_cubit.dart';

sealed class DeleteAllNotificationsState {}

final class DeleteAllNotificationsInitial extends DeleteAllNotificationsState {}

final class DeleteAllNotificationsLoading extends DeleteAllNotificationsState {}

final class DeleteAllNotificationsFailed extends DeleteAllNotificationsState {
  final String message;

  DeleteAllNotificationsFailed(this.message);
}

final class DeleteAllNotificationsSuccess extends DeleteAllNotificationsState {}
