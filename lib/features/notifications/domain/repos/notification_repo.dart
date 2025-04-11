import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/status_all_services_entity.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/unread_notifications_count_entity.dart';

import '../entities/user_trip_entity.dart';

abstract class NotificationRepo {
  Future<Either<Failure, List<NotificationEntity>>> fetchNotifications({
    required String type,
    required int page,
    int limit = 10,
    required String languageCode,
  });
  Future<void> setupInteractedMessage({
    required BuildContext context,
  });
  Future<void> notificationListener(
      {required Function(Map<String, dynamic> data) notificationCallback});

  Future<Either<Failure, UnreadNotificationsCountEntity>>
      getUnreadNotificationsCount();

  Future<Either<Failure, bool>> notificationSeen({required String id});
  Future<Either<Failure, bool>> allNotificationSeen({required String type});
  Future<Either<Failure, bool>> deleteNotification({required String id});
  Future<Either<Failure, bool>> deleteAllNotifications({required String type});
  Future<Either<Failure, List<UserTripEntity>>> getAllUserTrips();

  Future<Either<Failure, StatusAllServicesEntity>> getStatusAllServices();
}
