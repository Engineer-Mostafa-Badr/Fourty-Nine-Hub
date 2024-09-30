part of 'notification_seen_cubit.dart';

sealed class NotificationSeenState {}

final class NotificationSeenInitial extends NotificationSeenState {}

final class NotificationSeenLoading extends NotificationSeenState {}

final class NotificationSeenFailed extends NotificationSeenState {
  final String message;

  NotificationSeenFailed(this.message);
}

final class NotificationSeenSuccess extends NotificationSeenState {}
