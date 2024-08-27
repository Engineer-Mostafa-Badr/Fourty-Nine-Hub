import 'package:fourtyninehub/core/data/datasources/notification_data_source.dart';
import 'package:fourtyninehub/core/service/notification_service.dart';
import 'package:fourtyninehub/features/notifications/data/repostiory/notification_repostiory.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:get_it/get_it.dart';

class NotificationServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    //cubit
    serviceLocator.registerFactory(
      () => NotificationsCubit(serviceLocator()),
    );
    //datasource
    serviceLocator.registerLazySingleton(
      () => NotificationService(),
    );
    serviceLocator.registerLazySingleton<NotificationDataSource>(
      () => NotificationDataSourceImpl(serviceLocator(), serviceLocator()),
    );
    //repository
    serviceLocator.registerLazySingleton(
      () => NotificationRepostiory(dataSource: serviceLocator()),
    );
  }
}
