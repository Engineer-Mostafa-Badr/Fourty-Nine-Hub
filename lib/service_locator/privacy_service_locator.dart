import 'package:fourtyninehub/features/account_taps/privacy/data/data_source/privacy_data_source.dart';
import 'package:fourtyninehub/features/account_taps/privacy/data/repository/privacy_repository_impl.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/repository/privacy_repository.dart';
import 'package:fourtyninehub/features/account_taps/privacy/presentation/cubit/privacy_cubit.dart';
import 'package:get_it/get_it.dart';

import '../features/account_taps/privacy/domain/useCase/fetch_communication_privacy_use_case.dart';
import '../features/account_taps/privacy/domain/useCase/fetch_connection_privacy_use_case.dart';
import '../features/account_taps/privacy/domain/useCase/fetch_media_privacy_use_case.dart';
import '../features/account_taps/privacy/domain/useCase/fetch_personal_privacy_use_case.dart';
import '../features/account_taps/privacy/domain/useCase/search_users_privacy_use_case.dart';
import '../features/account_taps/privacy/domain/useCase/update_communication_privacy_use_case.dart';
import '../features/account_taps/privacy/domain/useCase/update_connection_privacy_use_case.dart';
import '../features/account_taps/privacy/domain/useCase/update_except_from_privacy_use_case.dart';
import '../features/account_taps/privacy/domain/useCase/update_media_privacy_use_case.dart';
import '../features/account_taps/privacy/domain/useCase/update_only_with_privacy_use_case.dart';
import '../features/account_taps/privacy/domain/useCase/update_personal_privacy_use_case.dart';

class PrivacyServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator
        .registerLazySingleton<PrivacyDataSource>(() => PrivacyDataSourceImpl(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<PrivacyRepository>(
        () => PrivacyRepositoryImpl(serviceLocator()));

    serviceLocator
        .registerLazySingleton<FetchPersonalPrivacyUseCase>(() => FetchPersonalPrivacyUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<FetchConnectionPrivacyUseCase>(() => FetchConnectionPrivacyUseCase(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<UpdatePersonalPrivacyUseCase>(() => UpdatePersonalPrivacyUseCase(
              serviceLocator(),
            ));
  serviceLocator
        .registerLazySingleton<UpdateConnectionPrivacyUseCase>(() => UpdateConnectionPrivacyUseCase(
              serviceLocator(),
            ));
  serviceLocator
        .registerLazySingleton<FetchCommunicationPrivacyUseCase>(() => FetchCommunicationPrivacyUseCase(
              serviceLocator(),
            ));
  serviceLocator
        .registerLazySingleton<UpdateCommunicationPrivacyUseCase>(() => UpdateCommunicationPrivacyUseCase(
              serviceLocator(),
            ));


  serviceLocator
        .registerLazySingleton<SearchUsersPrivacyUseCase>(() => SearchUsersPrivacyUseCase(
              serviceLocator(),
            ));
  serviceLocator
        .registerLazySingleton<UpdateOnlyWithPrivacyUseCase>(() => UpdateOnlyWithPrivacyUseCase(
              serviceLocator(),
            ));
  serviceLocator
        .registerLazySingleton<UpdateExceptFromPrivacyUseCase>(() => UpdateExceptFromPrivacyUseCase(
              serviceLocator(),
            ));
  serviceLocator
        .registerLazySingleton<FetchMediaPrivacyUseCase>(() => FetchMediaPrivacyUseCase(
              serviceLocator(),
            ));
  serviceLocator
        .registerLazySingleton<UpdateMediaPrivacyUseCase>(() => UpdateMediaPrivacyUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerFactory<PrivacyCubit>(() => PrivacyCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        )..loadData());
  }
}
