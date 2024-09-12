import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/domain/repos/notification_repo.dart';

class DeleteAllNotificationsUseCase {
  final NotificationRepo notificationRepo;

  DeleteAllNotificationsUseCase({required this.notificationRepo});
  Future<Either<Failure, bool>> call({required String type}) {
    return notificationRepo.deleteAllNotifications(type: type);
  }
}
