import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../service/notification_service.dart';

abstract class NotificationDataSource {
  Future<void> initNotification();
  Future<String?> getNotificationMobileAppId();
  Future<void> cancelNotification();
  Future<Either<Failure, Map<String, dynamic>>> getAllNotification();
}

class NotificationDataSourceImpl implements NotificationDataSource {
  final NotificationService _notificationService;
  final ApiConsumer api;
  NotificationDataSourceImpl(this._notificationService, this.api);

  @override
  Future<void> cancelNotification() => _notificationService.cancelAll();

  @override
  Future<String?> getNotificationMobileAppId() =>
      _notificationService.getDeviceTokenId();

  @override
  Future<void> initNotification() => _notificationService.inti();

  @override
  Future<Either<Failure, Map<String, dynamic>>> getAllNotification() {
    return api
        .get("https://9ad6cb01f298.ngrok-free.app/api/v1/notifications?type=app&limit=10&page=1");
  }
}
