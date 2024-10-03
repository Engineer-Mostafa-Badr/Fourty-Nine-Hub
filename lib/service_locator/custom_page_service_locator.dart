import 'package:fourtyninehub/features/custom_page/domain/use_case/fetch_social_page_use_case.dart';
import 'package:fourtyninehub/features/custom_page/domain/use_case/update_social_page_use_case.dart';
import 'package:get_it/get_it.dart';

import '../features/custom_page/data/data_source/custom_page_remote_data_source.dart';
import '../features/custom_page/data/reposiory/custom_page_repository_impl.dart';
import '../features/custom_page/domain/reposiory/custom_page_repository.dart';
import '../features/custom_page/domain/use_case/fetch_favourite_cat_use_case.dart';
import '../features/custom_page/domain/use_case/fetch_navigate_bar_use_case.dart';
import '../features/custom_page/domain/use_case/fetch_sub_tab_use_case.dart';
import '../features/custom_page/domain/use_case/update_favourite_cat_use_case.dart';
import '../features/custom_page/domain/use_case/update_navigate_bar_use_case.dart';
import '../features/custom_page/domain/use_case/update_sub_tab_use_case.dart';
import '../features/custom_page/presentation/cubit/custom_page_cubit.dart';

class CustomPageServiceLocator {
  static void execute({required GetIt serviceLocator}) {
    serviceLocator.registerLazySingleton<CustomPageRemoteDataSource>(
      () => CustomPageRemoteDataSourceImpl(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<CustomPageRepository>(
      () => CustomPageRepositoryImpl(
        serviceLocator(),
      ),
    );

    // use cases
    serviceLocator.registerLazySingleton<FetchSocialPageUseCase>(
      () => FetchSocialPageUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<UpdateSocialPageUseCase>(
      () => UpdateSocialPageUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<FetchSubTabUseCase>(
      () => FetchSubTabUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<UpdateSubTabUseCase>(
      () => UpdateSubTabUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<FetchNavigateBarUseCase>(
      () => FetchNavigateBarUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<UpdateNavigateBarUseCase>(
      () => UpdateNavigateBarUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<FetchFavouriteCatUseCase>(
      () => FetchFavouriteCatUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<UpdateFavouriteCatUseCase>(
      () => UpdateFavouriteCatUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerFactory<CustomPageCubit>(
      () => CustomPageCubit(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    );
  }
}
