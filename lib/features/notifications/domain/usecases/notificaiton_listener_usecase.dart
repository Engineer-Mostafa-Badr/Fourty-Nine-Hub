import 'package:fourtyninehub/features/notifications/domain/repos/notification_repo.dart';

class NotificationListenerUseCase {
  final NotificationRepo notificationRepo;

  NotificationListenerUseCase({required this.notificationRepo});

  Future<void> call({required Function(Map<String, dynamic> data) notificationCallback}) {
    return notificationRepo.notificationListener(notificationCallback: notificationCallback);
  }
}
