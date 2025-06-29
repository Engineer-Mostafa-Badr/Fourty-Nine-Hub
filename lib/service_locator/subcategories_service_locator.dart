import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/usecases/get_requests_log_by_main_category_use_case.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/get_my_favourite_ads_usecase.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/delete_ad_use_case.dart';
import 'package:fourtyninehub/features/subcategories/data/datasources/subcategories_remote_datasource.dart';
import 'package:fourtyninehub/features/subcategories/data/repositories/subcategories_repo_impl.dart';
import 'package:fourtyninehub/features/subcategories/domain/repositories/subcategories_repo.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/get_sub_categories_use_case.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/search_ads_use_case.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:get_it/get_it.dart';

import '../features/subcategories/domain/usecases/get_custom_page_sub_categories_use_case.dart';

class SubcategoriesServiceLocator {
  static void execute({required GetIt serviceLocator}) async {
    // -------------------Data Source ----------------------
    serviceLocator.registerLazySingleton<SubcategoriesRemoteDataSource>(
        () => SubcategoriesRemoteDataSourceImpl(serviceLocator()));
    // --------------------Repository ----------------------
    serviceLocator.registerLazySingleton<SubcategoriesRepo>(
        () => SubcategoriesRepoImpl(serviceLocator()));
    // -------------------Usecase -------------------------
    serviceLocator.registerLazySingleton<GetSubCategoriesUseCase>(
        () => GetSubCategoriesUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetCustomPageSubCategoriesUseCase>(
        () => GetCustomPageSubCategoriesUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetMyFavouriteAdsUsecase>(
        () => GetMyFavouriteAdsUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<SearchAdsUseCase>(
        () => SearchAdsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<DeleteAdUseCase>(
        () => DeleteAdUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetRequestsLogByMainCategoryUseCase>(
        () => GetRequestsLogByMainCategoryUseCase(serviceLocator()));
    // --------------------Cubit ---------------------------
    serviceLocator.registerFactory<SubcategoriesCubit>(() => SubcategoriesCubit(
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
          serviceLocator<DeleteAdUseCase>(),
          serviceLocator<GetRequestsLogByMainCategoryUseCase>(),
        ));
  }
}
