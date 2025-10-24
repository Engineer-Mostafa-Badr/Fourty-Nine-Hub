
import 'package:fourtyninehub/features/spotlight/data/datasource/spotlight_remote_datasource.dart';
import 'package:fourtyninehub/features/spotlight/data/repositories/spotlight_repo_impl.dart';
import 'package:fourtyninehub/features/spotlight/domain/usecases/get_spotlight_use_case.dart';
import 'package:fourtyninehub/features/tube/domain/usecases/get_all_tube_videos_use_case.dart';
import 'package:get_it/get_it.dart';

import '../features/spotlight/domain/repositories/spotlight_repo.dart';
import '../features/spotlight/presentation/cubit/spotlight_cubit.dart';
import '../features/tube/data/datasource/tube_remote_datasource.dart';
import '../features/tube/data/repositories/tube_repo_impl.dart';
import '../features/tube/domain/repositories/tube_repo.dart';
import '../features/tube/domain/usecases/add_favorite_tube_use_case.dart';
import '../features/tube/domain/usecases/get_tube_favorite_videos_use_case.dart';
import '../features/tube/domain/usecases/remove_favorite_tube_use_case.dart';
import '../features/tube/domain/usecases/search_tube_use_case.dart';
import '../features/tube/presentation/cubit/tube_cubit.dart';



class NewTubeServiceLocator {
  static void execute({required GetIt serviceLocator}) async {

    serviceLocator.registerLazySingleton<TubeRemoteDataSource>(() =>
        TubeRemoteDataSourceImpl(serviceLocator(),));

    serviceLocator.registerLazySingleton<GetAllTubeVideosUseCase>(
        () => GetAllTubeVideosUseCase(
              serviceLocator(),
            ));
   serviceLocator.registerLazySingleton<AddFavoriteTubeUseCase>(
        () => AddFavoriteTubeUseCase(
              serviceLocator(),
            ));
   serviceLocator.registerLazySingleton<RemoveFavoriteTubeUseCase>(
        () => RemoveFavoriteTubeUseCase(
              serviceLocator(),
            ));
   serviceLocator.registerLazySingleton<SearchTubeVideoUseCase>(
        () => SearchTubeVideoUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<GetTubeFavoriteVideosUseCase>(
        () => GetTubeFavoriteVideosUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<TubeRepository>(
        () => TubeRepoImpl(serviceLocator()));




    serviceLocator
        .registerFactory<TubeCubit>(() => TubeCubit(
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),


            ));
  }
}
