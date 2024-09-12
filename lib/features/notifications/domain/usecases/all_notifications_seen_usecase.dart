import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/domain/repos/notification_repo.dart';

class AllNotificationSeenUseCase {
  final NotificationRepo notificationRepo;

  AllNotificationSeenUseCase({required this.notificationRepo});
  Future<Either<Failure, bool>> call({required String type}) {
    return notificationRepo.allNotificationSeen(type: type);
  }
}
