import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubit/notifications_state.dart';

import '../../data/repository/notification_repo.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this.notificationRepo) : super(NotificationsInitial());

  final NotificationRepo notificationRepo;
  static NotificationsCubit get(context) => BlocProvider.of(context);

  Timer? _pollingTimer;

  void fetchNotification(String type) async {
    emit(NotificationsLoadingState());
    var result =await notificationRepo.fetchNotifications(type);

    result.fold((failure) {
      emit(NotificationsErrorState(errMessage: 'failure'));
    }, (notification) {
      emit(NotificationsSuccessState(notificationModel: notification));
    });
  }

  // void _startPolling(String type) {
  //   _pollingTimer?.cancel();
  //
  //   // Start polling every 10 seconds (adjust the interval as needed)
  //   _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
  //     var result =await notificationRepo.fetchNotifications(type);
  //
  //     result.fold((failure) {
  //       emit(NotificationsErrorState(errMessage: 'failure'));
  //     }, (notification) {
  //       emit(NotificationsSuccessState(notificationModel: notification));
  //     });
  //   });
  // }

  void deleteNotification({
    required String id,
  }) async {
    emit(DeleteNotificationsLoadingState());
    var result = await notificationRepo.deleteItemNotifications(id);

    result.fold((failure) {
      emit(DeleteNotificationsErrorState(errMessage: 'failure'));
      // print(failure.errMessage.toString());
    }, (notification) {
      emit(DeleteNotificationsSuccessState(deleteNotificationModel: notification));
    });
  }
}
