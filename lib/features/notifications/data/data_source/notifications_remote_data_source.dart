import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/data/models/notification_model/notification_model.dart';
import 'package:fourtyninehub/features/notifications/data/models/unread_notifications_count_model.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/unread_notifications_count_entity.dart';
import 'package:fourtyninehub/features/notifications/helpers/firebase_notification_helper.dart';
import 'package:fourtyninehub/features/notifications/helpers/web_socket_helper.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

abstract class NotificationsRemoteDataSource {
  Future<void> setupInteractedMessage({required BuildContext context});

  Future<Either<Failure, List<NotificationEntity>>> fetchNotifications({
    required String type,
    required int page,
    int limit = 10,
    required String languageCode,
  });
  Future<void> notificationListener(
      {required Function(Map<String, dynamic> data) notificationCallback});

  Future<Either<Failure, UnreadNotificationsCountEntity>>
      getUnreadNotificationsCount();
  Future<Either<Failure, bool>> notificationSeen({required String id});
  Future<Either<Failure, bool>> allNotificationSeen({required String type});
  Future<Either<Failure, bool>> deleteNotification({required String id});
  Future<Either<Failure, bool>> deleteAllNotifications({required String type});
}

class NotificationsRemoteDataSourceImp
    implements NotificationsRemoteDataSource {
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
    required String languageCode,
    int limit = 10,
  }) async {
    serviceLocator<Dio>().options.headers.remove('Accept-Language');
    serviceLocator<Dio>()
        .options
        .headers
        .addAll({'Accept-Language': getLang()});
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
        pr(data);
        List<NotificationEntity> notifications =
            (data['data']['docs'] as List).map<NotificationModel>((json) {
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
  Future<void> notificationListener(
      {required Function(Map<String, dynamic> data)
          notificationCallback}) async {
    webSocketHelper.notificationListener(notificationCallback);
  }

  @override
  Future<Either<Failure, UnreadNotificationsCountEntity>>
      getUnreadNotificationsCount() async {
    final response = await apiConsumer.get(EndPoints.unreadNotificationsCount);

    return response.fold(
      (failure) => Left(pr(failure)),
      (data) {
        // pr(data);
        UnreadNotificationsCountModel unreadNotificationsCountModel =
            UnreadNotificationsCountModel.fromJson(data['data']);
        pr(unreadNotificationsCountModel);
        return Right(unreadNotificationsCountModel);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> notificationSeen({required String id}) async {
    final response = await apiConsumer.put(EndPoints.notificationsSeen(id));

    return response.fold(
      (failure) => Left(pr(failure)),
      (data) {
        pr('Notification marked as seen');
        return const Right(true);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> allNotificationSeen(
      {required String type}) async {
    final response = await apiConsumer.put(
      EndPoints.notifications,
      queryParameters: {'type': type},
    );

    return response.fold(
      (failure) => Left(pr(failure)),
      (data) {
        pr('All Notification marked as seen');
        return const Right(true);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> deleteNotification({required String id}) async {
    final response = await apiConsumer.delete(
      EndPoints.deleteNotification(id),
    );

    return response.fold(
      (failure) => Left(pr(failure)),
      (data) {
        pr('Notificiation Deleted Successfully');
        return const Right(true);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> deleteAllNotifications(
      {required String type}) async {
    final response = await apiConsumer.delete(
      EndPoints.deleteAllNotification,
      queryParameters: {
        'type': type,
      },
    );

    return response.fold(
      (failure) => Left(pr(failure)),
      (data) {
        pr('All Notificiations Deleted Successfully');
        return const Right(true);
      },
    );
  }
}
