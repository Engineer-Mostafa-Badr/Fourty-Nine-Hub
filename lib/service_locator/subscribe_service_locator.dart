import '../features/subscripe/data/datasources/subscribe_remote_datasource.dart';
import '../features/subscripe/data/repositories/subscribtion_plans_repo_impl.dart';
import '../features/subscripe/domain/usecases/check_if_user_subscribed_usecase.dart';
import '../features/subscripe/domain/usecases/get_active_subscription_amounts.dart';
import '../features/subscripe/domain/usecases/get_subscription_plans_usecase.dart';
import '../features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:get_it/get_it.dart';

import '../features/subscripe/domain/repositories/subscription_plans_repo.dart';
import '../features/subscripe/domain/usecases/subscribe_usecase.dart';

class SubscriptionServiceLocator {
  static void execute({required GetIt serviceLocator}) async {
    // ================================== datasource =============================
    serviceLocator.registerLazySingleton<SubscribeRemoteDataSource>(
        () => SubscribeRemoteDataSourceImpl(
              serviceLocator(),
            ));
    // ================================== repo =============================
    serviceLocator.registerLazySingleton<SubscriptionPlansRepo>(
        () => SubscriptionPlansRepoImpl(
              serviceLocator(),
            ));
    // ================================== usecases =============================
    serviceLocator.registerLazySingleton<GetSubscriptionPlansUseCase>(
        () => GetSubscriptionPlansUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<CheckIfUserSubscribedUseCase>(
        () => CheckIfUserSubscribedUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<SubscribeUseCase>(() => SubscribeUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<GetActiveSubscriptionAmountsUseCase>(
        () => GetActiveSubscriptionAmountsUseCase(
              serviceLocator(),
            ));
    // ================================== cubits =============================
    serviceLocator.registerLazySingleton<SubscriptionController>(
        () => SubscriptionController(
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
            ));
  }
}
