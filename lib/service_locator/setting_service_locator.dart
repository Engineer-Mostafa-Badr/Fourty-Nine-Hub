import 'package:fourtyninehub/features/settings/data/data_source/setting_remote_data_source.dart';
import 'package:fourtyninehub/features/settings/data/repository/setting_repository_impl.dart';
import 'package:fourtyninehub/features/settings/domain/repository/setting_repository.dart';
import 'package:fourtyninehub/features/settings/domain/useCase/delete_account_use_case.dart';
import 'package:fourtyninehub/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:get_it/get_it.dart';

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

    serviceLocator.registerFactory<SettingCubit>(
            () => SettingCubit(
          serviceLocator(),
        ));
  }
}
