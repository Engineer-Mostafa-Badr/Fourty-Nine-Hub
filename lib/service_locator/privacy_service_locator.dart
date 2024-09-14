import 'package:fourtyninehub/features/account_taps/privacy/data/data_source/privacy_data_source.dart';
import 'package:fourtyninehub/features/account_taps/privacy/data/repository/privacy_repository_impl.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/repository/privacy_repository.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/useCase/fetch_privacy_use_case.dart';
import 'package:fourtyninehub/features/account_taps/privacy/presentation/cubit/privacy_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/data/datasources/company_advertise_data_source.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/data/repositories/company_advertise_repository_impl.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/repositories/company_advertise_repository.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/usecases/get_price_use_case.dart';
import 'package:get_it/get_it.dart';

import '../features/ads_feature/create_company_ad/domain/usecases/delete_company_ad_use_case.dart';
import '../features/ads_feature/create_company_ad/domain/usecases/get_company_add_use_case.dart';
import '../features/ads_feature/create_company_ad/domain/usecases/get_posts_company_ad_use_case.dart';
import '../features/ads_feature/create_company_ad/presentation/cubit/create_company_ad_cubit.dart';

class PrivacyServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<PrivacyDataSource>(
            () => PrivacyDataSourceImpl(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<PrivacyRepository>(
            () => PrivacyRepositoryImpl(serviceLocator()));

    serviceLocator
        .registerLazySingleton<FetchPrivacyUseCase>(() => FetchPrivacyUseCase(
      serviceLocator(),
    ));

    serviceLocator.registerFactory<PrivacyCubit>(
            () => PrivacyCubit(
          serviceLocator(),
        )..loadData());
  }
}
