import '../features/chance_feature/data/data_source/chance_remote_data_source.dart';
import '../features/chance_feature/data/repository/chance_repository_impl.dart';
import '../features/chance_feature/domain/repository/chance_repository.dart';
import '../features/chance_feature/domain/use_case/fetch_chance_rate_use_case.dart';
import '../features/chance_feature/domain/use_case/fetch_chance_use_case.dart';
import '../features/chance_feature/domain/use_case/fetch_main_category.dart';
import '../features/chance_feature/domain/use_case/fetch_sub_category.dart';
import 'package:get_it/get_it.dart';

import '../features/chance_feature/domain/use_case/add_chance_data.dart';
import '../features/chance_feature/domain/use_case/create_chance_ad_use_case.dart';
import '../features/chance_feature/domain/use_case/get_all_chance_ads_use_case.dart';
import '../features/chance_feature/domain/use_case/get_chance_ad_details_use_case.dart';
import '../features/chance_feature/domain/use_case/join_chance_ad_use_case.dart';
import '../features/chance_feature/domain/use_case/search_chance_ads_use_case.dart';
import '../features/chance_feature/domain/use_case/toggle_chance_ad_favorite_use_case.dart';
import '../features/chance_feature/domain/use_case/get_favorite_chance_ads_use_case.dart';
import '../features/chance_feature/domain/use_case/get_my_chance_ads_use_case.dart';
import '../features/chance_feature/presentation/controller/cubit/chance_cubit.dart';

class ChanceServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<ChanceRemoteDataSource>(
        () => ChanceRemoteDataSourceImpl(serviceLocator()));

    serviceLocator
        .registerLazySingleton<ChanceRepository>(() => ChanceRepositoryImpl(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<FetchChanceUseCase>(() => FetchChanceUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<AddChanceUseCase>(() => AddChanceUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<GetChanceRateUseCase>(() => GetChanceRateUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<MainCategoryChanceUseCase>(
        () => MainCategoryChanceUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<SubCategoryChanceUseCase>(
        () => SubCategoryChanceUseCase(
              serviceLocator(),
            ));

    // New Chance Ads Use Cases
    serviceLocator.registerLazySingleton<CreateChanceAdUseCase>(
        () => CreateChanceAdUseCase(serviceLocator()));

    serviceLocator.registerLazySingleton<JoinChanceAdUseCase>(
        () => JoinChanceAdUseCase(serviceLocator()));

    serviceLocator.registerLazySingleton<GetAllChanceAdsUseCase>(
        () => GetAllChanceAdsUseCase(serviceLocator()));

    serviceLocator.registerLazySingleton<GetChanceAdDetailsUseCase>(
        () => GetChanceAdDetailsUseCase(serviceLocator()));

    serviceLocator.registerLazySingleton<SearchChanceAdsUseCase>(
        () => SearchChanceAdsUseCase(serviceLocator()));

    serviceLocator.registerLazySingleton<ToggleChanceAdFavoriteUseCase>(
        () => ToggleChanceAdFavoriteUseCase(serviceLocator()));

    serviceLocator.registerLazySingleton<GetFavoriteChanceAdsUseCase>(
        () => GetFavoriteChanceAdsUseCase(serviceLocator()));

    serviceLocator.registerLazySingleton<GetMyChanceAdsUseCase>(
        () => GetMyChanceAdsUseCase(serviceLocator()));

    serviceLocator.registerFactory<ChanceCubit>(() => ChanceCubit(
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
