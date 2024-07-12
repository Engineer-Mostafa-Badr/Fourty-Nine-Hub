import 'package:fourtyninehub/features/account_taps/my_adds/data/datasources/my_add_remote_datasource.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/data/repositories/my_ads_repo_impl.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/repositories/my_ads_repo.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/get_my_ads_usecase.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/presentation/cubit/my_adds_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/data/datasources/ad_details_remote_data_source.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/domain/repositories/ad_details_repo.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/domain/usecases/get_ad_details_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/domain/usecases/get_relevant_ads_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/datasources/ads_remote_data_source.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/repositories/ads_repo.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/get_ads_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/data/datasources/create_ad_remote_datasource.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/data/repositories/create_ad_repo_impl.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/usecases/get_ad_properties_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/data/datasources/create_company_ad_remote_datasource.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/data/repositories/create_company_ad_repo_impl.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/repositories/create_company_ad_repo.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/usecases/get_company_ads_options_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/cubit/create_company_ad_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/data/data_sources/remote_data_source/fourty_nine_remote_data_source.dart';
import 'package:fourtyninehub/features/fourty_nine/data/repositories/fourty_nine_repository_impl.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/repositories/fourty_nine_repository.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_categories_use_case.dart';
import 'package:get_it/get_it.dart';
import '../features/ads_feature/ad_details/data/repositories/ad_details_repo_impl.dart';
import '../features/ads_feature/ad_details/presentation/cubit/ad_details_cubit.dart';
import '../features/ads_feature/ads/data/repositories/ads_repo_impl.dart';
import '../features/ads_feature/create_ad/domain/repositories/create_ad_repo.dart';
import '../features/ads_feature/create_ad/presentation/cubit/create_ad_cubit.dart';
import '../features/fourty_nine/domain/use_cases/get_parent_main_categories_use_case.dart';
import '../features/fourty_nine/domain/use_cases/get_slider_items_usecase.dart';
import '../features/fourty_nine/presentation/controllers/main_categories_cubit/parent_main_categories_cubit.dart';
import '../features/fourty_nine/presentation/controllers/parent_main_categories_cubit/main_categories_cubit.dart';
import '../features/fourty_nine/presentation/controllers/registable_sub_categories_cubit/registable_subcategories_cubit.dart';
import '../features/fourty_nine/presentation/controllers/slider_cubit.dart/slider_cubit.dart';
import '../features/subcategories/presentation/cubit/subcategories_cubit.dart';

class FourtyNineServiceLocator {
  static void execute(GetIt serviceLocator) {
    serviceLocator.registerLazySingleton<FourtyNineRemoteDataSource>(
      () => FourtyNineRemoteDataSourceImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<AdsRemoteDataSource>(
      () => AdsRemoteDataSourceImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<AdDetailsRemoteDataSource>(
      () => AdDetailsRemoteDataSourceImpl(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<CreateAdRemoteDatasource>(
      () => CreateAdRemoteDatasourceImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<CreateCompanyAdRemoteDataSource>(
      () => CreateCompanyAdRemoteDataSourceImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<MyAdsRemoteDatasource>(
      () => MyAdsRemoteDatasourceImpl(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<FourtyNineRepository>(
      () => FourtyNineRepositoryImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<AdsRepo>(
      () => AdsRepoImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<CreateCompanyAdRepo>(
      () => CreateCompanyAdRepoImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<AdDetailsRepo>(
      () => AdDetailsRepoImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<CreateAdRepo>(
      () => CreateAdRepoImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<MyAdsRepo>(
      () => MyAdsRepoImpl(
        serviceLocator(),
      ),
    );

    // use cases
    serviceLocator.registerLazySingleton<GetParentMainCategoriesUseCase>(
      () => GetParentMainCategoriesUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<GetMainCategoriesUseCase>(
      () => GetMainCategoriesUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetAdsUseCase>(
      () => GetAdsUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetAdDetailsUseCase>(
      () => GetAdDetailsUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetCompanyAdsOptionsUseCase>(
      () => GetCompanyAdsOptionsUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<GetAdPropertiesUsecase>(
      () => GetAdPropertiesUsecase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetRelevantAdsUseCase>(
      () => GetRelevantAdsUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetMyAdsUseCase>(
      () => GetMyAdsUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetSliderItemsUseCase>(
      () => GetSliderItemsUseCase(
        serviceLocator(),
      ),
    );

    // cubits
    serviceLocator.registerSingleton(
      ParentMainCategoriesCubit(
        serviceLocator(),
      )..getParentMainCategories(),
    );
    serviceLocator.registerSingleton(
      SliderCubit(
        serviceLocator(),
      )..loadData(),
    );
    serviceLocator.registerFactory<CreateCompanyAdCubit>(
      () => CreateCompanyAdCubit(
        serviceLocator(),
      )..loadData(),
    );
    serviceLocator.registerSingleton(
      RegistableSubCategoriesCubit(
        serviceLocator(),
      )..loadData(),
    );
    serviceLocator.registerFactory<MyAddsCubit>(
      () => MyAddsCubit(
        serviceLocator(),
      )..loadData(),
    );

    serviceLocator.registerSingleton(
      MainCategoriesCubit(
        serviceLocator(),
      )..getMainCategories(),
    );

    serviceLocator.registerSingleton(
      SubcategoriesCubit(
        serviceLocator(),
      )..loadData(),
    );
    serviceLocator.registerFactory<AdsCubit>(
      () => AdsCubit(
        serviceLocator(),
      )..loadData(),
    );
    // CreateAdCubit
    serviceLocator.registerFactory<CreateAdCubit>(
      () => CreateAdCubit(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      )..loadData(),
    );
    serviceLocator.registerFactory<AdDetailsCubit>(
      () => AdDetailsCubit(
        serviceLocator(),
        serviceLocator(),
      )..loadData(),
    );
  }
}
