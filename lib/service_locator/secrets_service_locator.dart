import '../secrets/controller/secrets_cubit.dart';
import '../secrets/data/data_source/secrets_data_source.dart';
import '../secrets/domain/repositories/secrets_repository_contract.dart';
import '../secrets/domain/use_cases/get_all_secrets_use_case.dart';
import 'package:get_it/get_it.dart';

import '../secrets/data/repositories/secrets_repository_impl.dart';

class SecretsServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<SecretsDataSource>(
        () => SecretsDataSourceImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<SecretsRepository>(
        () => SecretRepositoryImpl(serviceLocator()));
    serviceLocator.registerFactory<GetAllSecretsUseCase>(
        () => GetAllSecretsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<SecretsCubit>(
        () => SecretsCubit(serviceLocator()));
  }
}
