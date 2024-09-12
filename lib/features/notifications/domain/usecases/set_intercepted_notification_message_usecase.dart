import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/notifications/domain/repos/notification_repo.dart';

class SetInterceptedNotificationMessageUseCase {
  final NotificationRepo notificationRepo;

  SetInterceptedNotificationMessageUseCase({required this.notificationRepo});
  Future<void> call({required BuildContext context}) async {
    notificationRepo.setupInteractedMessage(context: context);
  }
}
