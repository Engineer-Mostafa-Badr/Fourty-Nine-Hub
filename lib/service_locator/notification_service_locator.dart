import 'package:fourtyninehub/features/notifications/data/data_source/notifications_remote_data_source.dart';
import 'package:fourtyninehub/features/notifications/data/repository/notification_repo_impl.dart';
import 'package:fourtyninehub/features/notifications/domain/repos/notification_repo.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/all_notifications_seen_usecase.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/delete_all_notifications_usecase.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/delete_notification_usecase.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/get_unread_notifications_usecase.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/notificaiton_listener_usecase.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/notification_seen_usecase.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/set_intercepted_notification_message_usecase.dart';
import 'package:fourtyninehub/features/notifications/helpers/firebase_notification_helper.dart';
import 'package:fourtyninehub/features/notifications/helpers/web_socket_helper.dart';
import 'package:get_it/get_it.dart';

import '../features/notifications/domain/usecases/get_all_user_trips_usecase.dart';
import '../features/notifications/domain/usecases/get_status_all_services_usecase.dart';
import '../features/notifications/presentation/cubits/get_status_all_services_notifications/get_status_all_services_notifications_cubit.dart';

class NotificationsServiceLocator {
  static execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<FirebaseHelper>(
      () => FirebaseHelper(),
    );
    serviceLocator.registerLazySingleton<NotificationsRemoteDataSource>(
      () => NotificationsRemoteDataSourceImp(
        firebaseHelper: serviceLocator(),
        apiConsumer: serviceLocator(),
        webSocketHelper: serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<NotificationRepo>(
      () => NotificationRepoImpl(
        notificationRemoteDataSource: serviceLocator(),
      ),
    );

    serviceLocator
        .registerLazySingleton<SetInterceptedNotificationMessageUseCase>(
      () => SetInterceptedNotificationMessageUseCase(
        notificationRepo: serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetNotificationsUseCase>(
      () => GetNotificationsUseCase(
        notificationRepo: serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<WebSocketHelper>(
      () => WebSocketHelper(),
    );
    serviceLocator.registerLazySingleton<NotificationListenerUseCase>(
      () => NotificationListenerUseCase(notificationRepo: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<GetUnreadNotificationsCountUseCase>(
      () => GetUnreadNotificationsCountUseCase(
          notificationRepo: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<NotificationSeenUseCase>(
      () => NotificationSeenUseCase(notificationRepo: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<AllNotificationSeenUseCase>(
      () => AllNotificationSeenUseCase(notificationRepo: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<DeleteNotificationUseCase>(
      () => DeleteNotificationUseCase(notificationRepo: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<DeleteAllNotificationsUseCase>(
      () => DeleteAllNotificationsUseCase(notificationRepo: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<GetStatusAllServicesUseCase>(
      () => GetStatusAllServicesUseCase(notificationRepo: serviceLocator()),
    );
    serviceLocator
        .registerLazySingleton<GetStatusAllServicesNotificationsCubit>(
      () => GetStatusAllServicesNotificationsCubit(serviceLocator()),
    );
  }
}
