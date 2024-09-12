part of 'get_social_notifications_cubit.dart';

sealed class GetSocialNotificationsState {}

final class GetSocialNotificationsInitial extends GetSocialNotificationsState {}

final class GetSocialNotificationsLoading extends GetSocialNotificationsState {}

final class GetSocialNotificationsFailed extends GetSocialNotificationsState {
  final String message;

  GetSocialNotificationsFailed(this.message);
}

final class GetSocialNotificationsSuccess extends GetSocialNotificationsState {
  final List<NotificationEntity> notifications;

  GetSocialNotificationsSuccess(this.notifications);
}
