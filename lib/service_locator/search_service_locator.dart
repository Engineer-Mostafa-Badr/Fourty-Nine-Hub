import '../features/search/data/data_source/search_remote_data_source.dart';
import '../features/search/data/repository/search_repository_impl.dart';
import '../features/search/domain/repository/search_repository.dart';
import '../features/search/domain/use_case/fetch_ads_search_use_case.dart';
import '../features/search/domain/use_case/fetch_posts_search_use_case.dart';
import '../features/search/domain/use_case/fetch_reel_search_use_case.dart';
import '../features/search/domain/use_case/fetch_search_sub_category_use_case.dart';
import '../features/search/domain/use_case/fetch_search_use_case.dart';
import '../features/search/domain/use_case/fetch_trip_come_search_use_case.dart';
import '../features/search/domain/use_case/fetch_user_search_use_case.dart';
import '../features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:get_it/get_it.dart';

class SearchServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<SearchRemoteDataSource>(
        () => SearchRemoteDataSourceImpl(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<FetchSearchUseCase>(() => FetchSearchUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<FetchSearchSubCategoryUseCase>(
        () => FetchSearchSubCategoryUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<FetchUserSearchUseCase>(
        () => FetchUserSearchUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<FetchAdsSearchUseCase>(
        () => FetchAdsSearchUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<FetchPostsSearchUseCase>(
        () => FetchPostsSearchUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<FetchTripComeSearchUseCase>(
        () => FetchTripComeSearchUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<FetchReelSearchUseCase>(
        () => FetchReelSearchUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerFactory<SearchCubit>(() => SearchCubit(
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
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ));
  }
}
