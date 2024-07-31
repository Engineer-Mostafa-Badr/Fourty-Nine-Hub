import 'package:fourtyninehub/features/subscribe/data/datasources/subscribe_remote_datasource.dart';
import 'package:fourtyninehub/features/subscribe/domain/usecases/check_if_user_subscribed_usecase.dart';
import 'package:fourtyninehub/features/subscribe/domain/usecases/get_subscribtion_plans_usecase.dart';
import 'package:fourtyninehub/features/subscribe/presentation/cubit/subscribe_cubit.dart';
import 'package:get_it/get_it.dart';

import '../features/subscribe/data/repositories/subscribtion_plans_repo_impl.dart';
import '../features/subscribe/domain/repositories/subscribtion_plans_repo.dart';
import '../features/subscribe/domain/usecases/subscribe_usecase.dart';

class SubscribtionServiceLocator {
  static void execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<SubscribeRemoteDataSource>(
        () => SubscribeRemoteDataSourceImpl(
              serviceLocator(),
            ));
             serviceLocator.registerLazySingleton<SubscribtionPlansRepo>(
        () => SubscribtionPlansRepoImpl(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<GetSubscribtionPlansUseCase>(
        () => GetSubscribtionPlansUseCase(
              serviceLocator(),
            ));
            serviceLocator.registerLazySingleton<CheckIfUserSubscribedUseCase>(
        () => CheckIfUserSubscribedUseCase(
              serviceLocator(),
            ));
            serviceLocator.registerLazySingleton<SubscribeUseCase>(
        () => SubscribeUseCase(
              serviceLocator(),
            ));
            serviceLocator.registerFactory<SubscribeCubit>(()=>SubscribeCubit(
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
            ));
  }
}
