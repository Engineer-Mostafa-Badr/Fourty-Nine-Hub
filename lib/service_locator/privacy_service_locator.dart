import 'package:fourtyninehub/features/account_taps/privacy/data/data_source/privacy_data_source.dart';
import 'package:fourtyninehub/features/account_taps/privacy/data/repository/privacy_repository_impl.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/repository/privacy_repository.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/useCase/fetch_privacy_use_case.dart';
import 'package:fourtyninehub/features/account_taps/privacy/presentation/cubit/privacy_cubit.dart';
import 'package:get_it/get_it.dart';

class PrivacyServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<PrivacyDataSource>(
            () => PrivacyDataSourceImpl(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<PrivacyRepository>(
            () => PrivacyRepositoryImpl(serviceLocator()));

    serviceLocator
        .registerLazySingleton<FetchPrivacyUseCase>(() => FetchPrivacyUseCase(
      serviceLocator(),
    ));

    serviceLocator.registerFactory<PrivacyCubit>(
            () => PrivacyCubit(
          serviceLocator(),
        )..loadData());
  }
}
