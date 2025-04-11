import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/data/data_source/notifications_remote_data_source.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/status_all_services_entity.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/unread_notifications_count_entity.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/user_trip_entity.dart';

import '../../domain/repos/notification_repo.dart';

class NotificationRepoImpl implements NotificationRepo {
  final NotificationsRemoteDataSource notificationRemoteDataSource;
  NotificationRepoImpl({
    required this.notificationRemoteDataSource,
  });
  @override
  Future<Either<Failure, List<NotificationEntity>>> fetchNotifications({
    required String type,
    required int page,
    int limit = 10,
    required String languageCode,
  }) async {
    return notificationRemoteDataSource.fetchNotifications(
        type: type, page: page, limit: limit, languageCode: languageCode);
  }

  @override
  Future<void> setupInteractedMessage({
    required BuildContext context,
  }) async {
    notificationRemoteDataSource.setupInteractedMessage(context: context);
  }

  @override
  Future<void> notificationListener(
      {required Function(Map<String, dynamic> data) notificationCallback}) {
    return notificationRemoteDataSource.notificationListener(
        notificationCallback: notificationCallback);
  }

  @override
  Future<Either<Failure, UnreadNotificationsCountEntity>>
      getUnreadNotificationsCount() {
    return notificationRemoteDataSource.getUnreadNotificationsCount();
  }

  @override
  Future<Either<Failure, bool>> notificationSeen({required String id}) {
    return notificationRemoteDataSource.notificationSeen(id: id);
  }

  @override
  Future<Either<Failure, bool>> allNotificationSeen({required String type}) {
    return notificationRemoteDataSource.allNotificationSeen(type: type);
  }

  @override
  Future<Either<Failure, bool>> deleteNotification({required String id}) {
    return notificationRemoteDataSource.deleteNotification(id: id);
  }

  @override
  Future<Either<Failure, bool>> deleteAllNotifications({required String type}) {
    return notificationRemoteDataSource.deleteAllNotifications(type: type);
  }

  @override
  Future<Either<Failure, List<UserTripEntity>>> getAllUserTrips() {
    return notificationRemoteDataSource.getAllUserTrips();

  }

  @override
  Future<Either<Failure, StatusAllServicesEntity>> getStatusAllServices() {
    return notificationRemoteDataSource.getStatusAllServices();

  }
}
