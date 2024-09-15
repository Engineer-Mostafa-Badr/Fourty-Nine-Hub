import 'package:fourtyninehub/features/ads_feature/create_company_ad/data/datasources/company_advertise_data_source.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/data/repositories/company_advertise_repository_impl.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/repositories/company_advertise_repository.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/usecases/get_price_use_case.dart';
import 'package:get_it/get_it.dart';

import '../features/ads_feature/create_company_ad/domain/usecases/delete_company_ad_use_case.dart';
import '../features/ads_feature/create_company_ad/domain/usecases/get_company_add_use_case.dart';
import '../features/ads_feature/create_company_ad/domain/usecases/get_posts_company_ad_use_case.dart';
import '../features/ads_feature/create_company_ad/presentation/cubit/create_company_ad_cubit.dart';

class CompanyAddServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<CompanyAdvertiseDataSource>(
        () => CompanyAdvertiseDataSourceImpl(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<CompanyAdvertiseRepository>(
        () => CompanyAdvertiseRepositoryImpl(serviceLocator()));

    serviceLocator
        .registerLazySingleton<GetPriceUseCases>(() => GetPriceUseCases(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<GetCompanyAddUseCases>(
        () => GetCompanyAddUseCases(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<DeleteCompanyAddUseCases>(
        () => DeleteCompanyAddUseCases(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<GetPostsCompanyAdUseCase>(
        () => GetPostsCompanyAdUseCase(
              serviceLocator(),
            ));

    serviceLocator
        .registerFactory<CreateCompanyAdCubit>(() => CreateCompanyAdCubit(
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
            )..loadData());
  }
}
