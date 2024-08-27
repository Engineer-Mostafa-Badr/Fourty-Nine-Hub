part of 'notifications_cubit.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class SuccessGetAllNotificationState extends NotificationsState {
  // final List<NotificationModel> notifications;
}
