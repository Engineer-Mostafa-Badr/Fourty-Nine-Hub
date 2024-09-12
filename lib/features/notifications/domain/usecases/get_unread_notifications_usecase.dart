import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/unread_notifications_count_entity.dart';
import 'package:fourtyninehub/features/notifications/domain/repos/notification_repo.dart';

class GetUnreadNotificationsCountUseCase {
  final NotificationRepo notificationRepo;

  GetUnreadNotificationsCountUseCase({required this.notificationRepo});
  Future<Either<Failure, UnreadNotificationsCountEntity>> call() {
    return notificationRepo.getUnreadNotificationsCount();
  }
}
