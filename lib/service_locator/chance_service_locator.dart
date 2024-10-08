import 'package:fourtyninehub/features/chance_feature/data/data_source/chance_remote_data_source.dart';
import 'package:fourtyninehub/features/chance_feature/data/repository/chance_repository_impl.dart';
import 'package:fourtyninehub/features/chance_feature/domain/repository/chance_repository.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_chance_use_case.dart';
import 'package:get_it/get_it.dart';

import '../features/chance_feature/presentation/controller/cubit/chance_cubit.dart';

class ChanceServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<ChanceRemoteDataSource>(
            () => ChanceRemoteDataSourceImpl(
          serviceLocator(),
        ));

    serviceLocator
        .registerLazySingleton<ChanceRepository>(() => ChanceRepositoryImpl(
      serviceLocator(),
    ));

    serviceLocator
        .registerLazySingleton<FetchChanceUseCase>(() => FetchChanceUseCase(
      serviceLocator(),
    ));

    serviceLocator.registerFactory<ChanceCubit>(() => ChanceCubit(
      serviceLocator()
    ));
  }
}
