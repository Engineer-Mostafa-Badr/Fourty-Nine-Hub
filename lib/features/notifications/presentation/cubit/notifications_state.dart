import '../../../../core/data/models/notification_model.dart';
import '../../data/models/delete_notification_model.dart';

abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoadingState extends NotificationsState {}

class NotificationsSuccessState extends NotificationsState {
  final NotificationModel notificationModel;

  NotificationsSuccessState({required this.notificationModel});
}

class NotificationsErrorState extends NotificationsState {
  final String errMessage;

  NotificationsErrorState({required this.errMessage});
}

class DeleteNotificationsLoadingState extends NotificationsState {}

class DeleteNotificationsSuccessState extends NotificationsState {
  final DeleteNotificationModel deleteNotificationModel;

  DeleteNotificationsSuccessState({required this.deleteNotificationModel});
}

class DeleteNotificationsErrorState extends NotificationsState {
  final String errMessage;

  DeleteNotificationsErrorState({required this.errMessage});
}
