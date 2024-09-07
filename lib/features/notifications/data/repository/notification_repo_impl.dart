import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/data/data_source/notifications_remote_data_source.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';

import '../../domain/repos/notification_repo.dart';
import '../models/delete_notification_model.dart';

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
  }) async {
    return notificationRemoteDataSource.fetchNotifications(type: type, page: page, limit: limit);
  }

  @override
  Future<Either<Failure, DeleteNotificationModel>> deleteItemNotifications(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> setupInteractedMessage({
    required BuildContext context,
  }) async {
    notificationRemoteDataSource.setupInteractedMessage(context: context);
  }

  @override
  Future<void> notificationListener({required Function(Map<String, dynamic> data) notificationCallback}) {
    return notificationRemoteDataSource.notificationListener(notificationCallback: notificationCallback);
  }
}
