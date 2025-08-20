import '../features/azkaar/data/data_source/azkar_remote_data_source.dart';
import '../features/azkaar/data/repositoy/azkar_repository_impl.dart';
import '../features/azkaar/domain/repository/azkar_repository.dart';
import '../features/azkaar/domain/use_case/fetch_azkar_use_case.dart';
import '../features/azkaar/domain/use_case/fetch_details_azkar_use_case.dart';
import '../features/azkaar/presentation/cubit/azkaar_cubit.dart';
import '../features/quraan/data/data_sources/quran_remote_data_source.dart';
import '../features/quraan/data/repository/quran_repository_impl.dart';
import '../features/quraan/domain/repository/quran_repository.dart';
import '../features/quraan/domain/use_case/fetch_quran_surah_use_case.dart';
import '../features/quraan/domain/use_case/fetch_surah_use_case.dart';
import '../features/quraan/presentation/cubit/quraan_cubit.dart';
import 'package:get_it/get_it.dart';

import '../features/azkaar/domain/use_case/search_azkar_usecase.dart';

class QuranServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<QuranRemoteDataSource>(
        () => QuranRemoteDataSourceImpl(serviceLocator()));

    serviceLocator
        .registerLazySingleton<QuranRepository>(() => QuranRepositoryImpl(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<FetchQuranSurahUseCase>(
        () => FetchQuranSurahUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<FetchSurahUseCase>(() => FetchSurahUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerFactory<QuranCubit>(() => QuranCubit(
          serviceLocator(),
          serviceLocator(),
        ));

    // Akar
    serviceLocator.registerLazySingleton<AzkarRemoteDataSource>(
        () => AzkarRemoteDataSourceImpl(serviceLocator()));

    serviceLocator
        .registerLazySingleton<AzkarRepository>(() => AzkarRepositoryImpl(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<FetchAzkarUseCase>(() => FetchAzkarUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<FetchDetailsAzkarUseCase>(
        () => FetchDetailsAzkarUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<SearchAzkarUseCase>(() => SearchAzkarUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerFactory<AzkarCubit>(() => AzkarCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ));
  }
}
