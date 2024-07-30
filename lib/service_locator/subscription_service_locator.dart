import 'package:fourtyninehub/features/subscription/data/datasources/subscription_remote_datasource.dart';
import 'package:fourtyninehub/features/subscription/data/repositories/subscription_repo_impl.dart';
import 'package:fourtyninehub/features/subscription/domain/repositories/subscription_repo.dart';
import 'package:fourtyninehub/features/subscription/domain/usecases/get_subscription_plan_usecase.dart';
import 'package:fourtyninehub/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:get_it/get_it.dart';

class SubscriptionServiceLocator {
  // ====================================  Data sources  ===================================
  static void execute(GetIt serviceLocator) {
    serviceLocator.registerLazySingleton<SubscriptionRemoteDataSource>(
        () => SubscriptionRemoteDataSourceImpl(serviceLocator()));

    // ====================================  usecases  ===================================

    serviceLocator.registerLazySingleton<GetSubscriptionPlansUseCase>(
        () => GetSubscriptionPlansUseCase(serviceLocator()));

    // ====================================  repository  ===================================

    serviceLocator.registerLazySingleton<SubscriptionRepo>(
        () => SubscriptionRepoImpl(serviceLocator()));

    // =====================================  cubits  ===================================

    serviceLocator.registerFactory<SubscriptionCubit>(
        () => SubscriptionCubit(serviceLocator()));
  }
}
