import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/unread_notifications_count_entity.dart';

import '../../data/models/delete_notification_model.dart';

abstract class NotificationRepo {
  Future<Either<Failure, List<NotificationEntity>>> fetchNotifications({
    required String type,
    required int page,
    int limit = 10,
  });
  Future<Either<Failure, DeleteNotificationModel>> deleteItemNotifications(String id);
  Future<void> setupInteractedMessage({
    required BuildContext context,
  });
  Future<void> notificationListener({required Function(Map<String, dynamic> data) notificationCallback});

  Future<Either<Failure, UnreadNotificationsCountEntity>> getUnreadNotificationsCount();
}
