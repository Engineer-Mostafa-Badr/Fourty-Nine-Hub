import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/data/models/notification_model/notification_model.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fourtyninehub/features/notifications/helpers/firebase_notification_helper.dart';
import 'package:fourtyninehub/features/notifications/helpers/web_socket_helper.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';

abstract class NotificationsRemoteDataSource {
  Future<void> setupInteractedMessage({required BuildContext context});
  Future<Either<Failure, List<NotificationEntity>>> fetchNotifications({
    required String type,
    required int page,
    int limit = 10,
  });
  Future<void> notificationListener({required Function(Map<String, dynamic> data) notificationCallback});
}

class NotificationsRemoteDataSourceImp implements NotificationsRemoteDataSource {
  final FirebaseHelper firebaseHelper;
  final ApiConsumer apiConsumer;
  final WebSocketHelper webSocketHelper;

  NotificationsRemoteDataSourceImp({
    required this.firebaseHelper,
    required this.apiConsumer,
    required this.webSocketHelper,
  });

  @override
  Future<void> setupInteractedMessage({required BuildContext context}) async {
    firebaseHelper.initFirebaseHelper(context);
    await firebaseHelper.setupInteractedMessage();
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>> fetchNotifications({
    required String type,
    required int page,
    int limit = 10,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.notifications,
      queryParameters: {
        'type': type,
        'page': page,
        'limit': limit,
      },
    );

    return response.fold(
      (failure) => Left(pr(failure)),
      (data) {
        // pr(data);
        List<NotificationEntity> notifications = (data['data']['docs'] as List).map<NotificationModel>((json) {
          NotificationModel notification = NotificationModel.fromJson(json);
          notification.hasNextPage = hasNextPage(data);
          notification.nextPageNumber = nextPageNumber(data);
          return notification;
        }).toList();
        pr(notifications);
        return Right(notifications);
      },
    );
  }

  bool? hasNextPage(Map<String, dynamic> json) {
    return json['data']['hasNextPage'] as bool?;
  }

  int? nextPageNumber(json) {
    return json['data']['nextPage'] as int?;
  }

  @override
  Future<void> notificationListener({required Function(Map<String, dynamic> data) notificationCallback}) async {
    webSocketHelper.notificationListener(notificationCallback);
  }
}
