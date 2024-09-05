import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/models/notification_model.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../models/delete_notification_model.dart';

abstract class NotificationRepo{
  Future<Either<Failure,NotificationModel>> fetchNotifications(String type);
  Future<Either<Failure,DeleteNotificationModel>> deleteItemNotifications(String id);
}