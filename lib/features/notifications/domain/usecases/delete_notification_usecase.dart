import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/domain/repos/notification_repo.dart';

class DeleteNotificationUseCase {
  final NotificationRepo notificationRepo;

  DeleteNotificationUseCase({required this.notificationRepo});
  Future<Either<Failure, bool>> call({required String id}) {
    return notificationRepo.deleteNotification(id: id);
  }
}
