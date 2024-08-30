import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel(
      {required super.id,
      required super.message,
      required super.itemId,
      super.route,
      required super.createdAt});
}
