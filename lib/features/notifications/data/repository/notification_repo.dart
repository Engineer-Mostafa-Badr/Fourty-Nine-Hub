import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/models/notification_model.dart';
import 'package:fourtyninehub/core/error/failure.dart';

abstract class NotificationRepo{
  Future<Either<Failure,NotificationModel>> fetchNotifications();
}