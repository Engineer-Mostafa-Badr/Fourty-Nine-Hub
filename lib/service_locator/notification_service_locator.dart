import 'package:fourtyninehub/features/notifications/data/data_source/notifications_remote_data_source.dart';
import 'package:fourtyninehub/features/notifications/data/repository/notification_repo_impl.dart';
import 'package:fourtyninehub/features/notifications/domain/repos/notification_repo.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/set_intercepted_notification_message_usecase.dart';
import 'package:fourtyninehub/features/notifications/helpers/firebase_notification_helper.dart';
import 'package:fourtyninehub/features/notifications/helpers/web_socket_helper.dart';
import 'package:get_it/get_it.dart';

class NotificationsServiceLocator {
  static void execute({required GetIt serviceLocator}) {
    serviceLocator.registerLazySingleton<FirebaseHelper>(
      () => FirebaseHelper(),
    );
    serviceLocator.registerLazySingleton<NotificationsRemoteDataSource>(
      () => NotificationsRemoteDataSourceImp(
        firebaseHelper: serviceLocator(),
        apiConsumer: serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<NotificationRepo>(
      () => NotificationRepoImpl(
        notificationRemoteDataSource: serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<SetInterceptedNotificationMessageUseCase>(
      () => SetInterceptedNotificationMessageUseCase(
        notificationRepo: serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetNotficationsUseCase>(
      () => GetNotficationsUseCase(
        notificationRepo: serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<WebSocketHelper>(
      () => WebSocketHelper(),
    );
  }
}
