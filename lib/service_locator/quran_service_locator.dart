import 'package:fourtyninehub/features/azkaar/data/data_source/azkar_remote_data_source.dart';
import 'package:fourtyninehub/features/azkaar/data/repositoy/azkar_repository_impl.dart';
import 'package:fourtyninehub/features/azkaar/domain/repository/azkar_repository.dart';
import 'package:fourtyninehub/features/azkaar/domain/use_case/fetch_azkar_use_case.dart';
import 'package:fourtyninehub/features/azkaar/domain/use_case/fetch_details_azkar_use_case.dart';
import 'package:fourtyninehub/features/azkaar/presentation/cubit/azkaar_cubit.dart';
import 'package:fourtyninehub/features/quraan/data/data_sources/quran_remote_data_source.dart';
import 'package:fourtyninehub/features/quraan/data/repository/quran_repository_impl.dart';
import 'package:fourtyninehub/features/quraan/domain/repository/quran_repository.dart';
import 'package:fourtyninehub/features/quraan/domain/use_case/fetch_quran_surah_use_case.dart';
import 'package:fourtyninehub/features/quraan/domain/use_case/fetch_surah_use_case.dart';
import 'package:fourtyninehub/features/quraan/presentation/cubit/quraan_cubit.dart';
import 'package:get_it/get_it.dart';

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
    serviceLocator
        .registerLazySingleton<FetchDetailsAzkarUseCase>(() => FetchDetailsAzkarUseCase(
      serviceLocator(),
    ));

    serviceLocator.registerFactory<AzkarCubit>(() => AzkarCubit(
      serviceLocator(),
      serviceLocator(),
    ));


  }
}
