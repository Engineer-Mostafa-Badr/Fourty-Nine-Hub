import '../features/settings/data/data_source/setting_remote_data_source.dart';
import '../features/settings/data/repository/setting_repository_impl.dart';
import '../features/settings/domain/repository/setting_repository.dart';
import '../features/settings/domain/useCase/delete_account_use_case.dart';
import '../features/settings/presentation/cubit/settings_cubit.dart';
import 'package:get_it/get_it.dart';

import '../features/settings/domain/useCase/disable_account_use_case.dart';
import '../features/settings/domain/useCase/enable_account_use_case.dart';

class SettingServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<SettingRemoteDataSource>(
        () => SettingRemoteDataSourceImpl(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<SettingRepository>(
        () => SettingRepositoryImpl(serviceLocator()));

    serviceLocator
        .registerLazySingleton<DeleteAccountUseCase>(() => DeleteAccountUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<DisableAccountUseCase>(
        () => DisableAccountUseCase(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<EnableAccountUseCase>(() => EnableAccountUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerFactory<SettingCubit>(() => SettingCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ));
  }
}
