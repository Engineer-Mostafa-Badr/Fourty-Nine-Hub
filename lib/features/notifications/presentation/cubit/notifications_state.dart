import '../../../../core/data/models/notification_model.dart';

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
