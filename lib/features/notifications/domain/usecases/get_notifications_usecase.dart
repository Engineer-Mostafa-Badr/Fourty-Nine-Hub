import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fourtyninehub/features/notifications/domain/repos/notification_repo.dart';

class GetNotficationsUseCase {
  final NotificationRepo notificationRepo;

  GetNotficationsUseCase({required this.notificationRepo});
  Future<Either<Failure, List<NotificationEntity>>> call({
    required String type,
    required int page,
    int limit = 10,
    required String languageCode,
  }) {
    return notificationRepo.fetchNotifications(type: type, page: page, languageCode: languageCode);
  }
}
