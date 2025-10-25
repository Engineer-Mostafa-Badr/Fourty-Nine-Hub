
import 'package:fourtyninehub/features/spotlight/data/datasource/spotlight_remote_datasource.dart';
import 'package:fourtyninehub/features/spotlight/data/repositories/spotlight_repo_impl.dart';
import 'package:fourtyninehub/features/spotlight/domain/usecases/get_spotlight_use_case.dart';
import 'package:get_it/get_it.dart';

import '../features/spotlight/domain/repositories/spotlight_repo.dart';
import '../features/spotlight/presentation/cubit/spotlight_cubit.dart';



class SpotlightServiceLocator {
  static void execute({required GetIt serviceLocator}) async {

    serviceLocator.registerLazySingleton<SpotlightRemoteDataSource>(() =>
        SpotlightRemoteDataSourceImpl(serviceLocator(),));

    serviceLocator.registerLazySingleton<GetSpotlightUseCase>(
        () => GetSpotlightUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<SpotlightRepository>(
        () => SpotlightRepoImpl(serviceLocator()));




    serviceLocator
        .registerFactory<SpotlightCubit>(() => SpotlightCubit(
              serviceLocator(),


            ));
  }
}
