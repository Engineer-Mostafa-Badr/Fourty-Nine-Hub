part of 'get_unread_notifications_count_cubit.dart';

sealed class GetUnreadNotificationsCountState {}

final class GetUnreadNotificationsCountInitial extends GetUnreadNotificationsCountState {}

final class GetUnreadNotificationsCountLoading extends GetUnreadNotificationsCountState {}

final class GetUnreadNotificationsCountFailed extends GetUnreadNotificationsCountState {
  final String message;

  GetUnreadNotificationsCountFailed(this.message);
}

final class GetUnreadNotificationsCountSuccess extends GetUnreadNotificationsCountState {
  final UnreadNotificationsCountEntity unreadNotificationsCountEntity;

  GetUnreadNotificationsCountSuccess(this.unreadNotificationsCountEntity);
}
