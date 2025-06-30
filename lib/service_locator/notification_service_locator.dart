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
import 'package:fourtyninehub/features/notifications/data/data_source/notifications_remote_data_source.dart';
import 'package:fourtyninehub/features/notifications/data/repository/notification_repo_impl.dart';
import 'package:fourtyninehub/features/notifications/data/repostiory/notification_repostiory.dart';
import 'package:fourtyninehub/features/notifications/domain/repos/notification_repo.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/all_notifications_seen_usecase.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/delete_all_notifications_usecase.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/delete_notification_usecase.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/get_all_user_trips_usecase.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/get_status_all_services_usecase.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/get_unread_notifications_usecase.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/notificaiton_listener_usecase.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/notification_seen_usecase.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/set_intercepted_notification_message_usecase.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/all_notifications_seen/all_notfications_seen_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/delete_all_notifications/delete_all_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/delete_notification/delete_notification_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/firebase_notfications_cubit/firebase_notfications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_app_notifications/get_app_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_services_notifications/get_services_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_social_notifications/get_social_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_status_all_services_notifications/get_status_all_services_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_unread_notifications_count/get_unread_notifications_count_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/notification_seen/notification_seen_cubit.dart';
import 'package:fourtyninehub/main.dart';
import 'package:fourtyninehub/res/style/const.dart';

class NotificationsServiceLocator {
  static execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<FirebaseHelper>(
      () => FirebaseHelper(),
    );
    serviceLocator.registerLazySingleton<NotificationsRemoteDataSource>(
      () => NotificationsRemoteDataSourceImp(
        apiConsumer: serviceLocator(),
        firebaseHelper: serviceLocator(),
        // webSocketHelper: serviceLocator()
      ),
    );

    // Register repository
    serviceLocator.registerLazySingleton<NotificationRepo>(
      () =>
          NotificationRepoImpl(notificationRemoteDataSource: serviceLocator()),
    );

    serviceLocator.registerLazySingleton<NotificationRepostiory>(
      () => NotificationRepostiory(dataSource: serviceLocator()),
    );

    // Register use cases
    serviceLocator.registerLazySingleton<AllNotificationSeenUseCase>(
      () => AllNotificationSeenUseCase(notificationRepo: serviceLocator()),
    );

    serviceLocator.registerLazySingleton<GetNotificationsUseCase>(
      () => GetNotificationsUseCase(notificationRepo: serviceLocator()),
    );

    serviceLocator.registerLazySingleton<GetStatusAllServicesUseCase>(
      () => GetStatusAllServicesUseCase(notificationRepo: serviceLocator()),
    );

    serviceLocator.registerLazySingleton<DeleteAllNotificationsUseCase>(
      () => DeleteAllNotificationsUseCase(notificationRepo: serviceLocator()),
    );

    serviceLocator.registerLazySingleton<DeleteNotificationUseCase>(
      () => DeleteNotificationUseCase(notificationRepo: serviceLocator()),
    );

    serviceLocator.registerLazySingleton<GetAllUserTripsUseCase>(
      () => GetAllUserTripsUseCase(notificationRepo: serviceLocator()),
    );

    serviceLocator.registerLazySingleton<GetUnreadNotificationsCountUseCase>(
      () => GetUnreadNotificationsCountUseCase(
          notificationRepo: serviceLocator()),
    );

    serviceLocator.registerLazySingleton<NotificationListenerUseCase>(
      () => NotificationListenerUseCase(notificationRepo: serviceLocator()),
    );

    serviceLocator.registerLazySingleton<NotificationSeenUseCase>(
      () => NotificationSeenUseCase(notificationRepo: serviceLocator()),
    );

    serviceLocator
        .registerLazySingleton<SetInterceptedNotificationMessageUseCase>(
      () => SetInterceptedNotificationMessageUseCase(
          notificationRepo: serviceLocator()),
    );

    // cubits
    serviceLocator.registerFactory<AllNotficationsSeenCubit>(
      () => AllNotficationsSeenCubit(
          allNotificationSeenUseCase: serviceLocator()),
    );

    serviceLocator.registerFactory<DeleteAllNotificationsCubit>(
      () => DeleteAllNotificationsCubit(
          deleteAllNotificationsUseCase: serviceLocator()),
    );

    serviceLocator.registerFactory<DeleteNotificationCubit>(
      () =>
          DeleteNotificationCubit(deleteNotificationUseCase: serviceLocator()),
    );

    serviceLocator.registerFactory<FirebaseNotficationsCubit>(
      () => FirebaseNotficationsCubit(serviceLocator()),
    );

    serviceLocator.registerFactory<GetAppNotificationsCubit>(
      () => GetAppNotificationsCubit(
          getNotficationsUseCase: serviceLocator(),
          context: navigatorKey.currentContext!),
    );

    serviceLocator.registerFactory<GetServicesNotificationsCubit>(
      () => GetServicesNotificationsCubit(
          getNotficationsUseCase: serviceLocator(),
          context: navigatorKey.currentContext!),
    );

    serviceLocator.registerFactory<GetSocialNotificationsCubit>(
      () => GetSocialNotificationsCubit(
          getNotficationsUseCase: serviceLocator(),
          context: navigatorKey.currentContext!),
    );

    serviceLocator.registerFactory(() => GetStatusAllServicesNotificationsCubit(
          serviceLocator(),
        ));

    serviceLocator.registerFactory<GetUnreadNotificationsCountCubit>(
        () => GetUnreadNotificationsCountCubit(
              getUnreadNotificationsCountUseCase: serviceLocator(),
            ));

    serviceLocator
        .registerFactory<NotificationSeenCubit>(() => NotificationSeenCubit(
              notificationSeenUseCase: serviceLocator(),
            ));
  }
}
