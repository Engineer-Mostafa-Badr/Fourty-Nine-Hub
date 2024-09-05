import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fourtyninehub/core/api/google_api_consumer.dart';
import 'package:fourtyninehub/core/api/interceptors/subscription_interceptor.dart';
import 'package:fourtyninehub/features/trip_join/data/remote_data_source/fetch_location_remote_datasource.dart';
import 'package:fourtyninehub/features/trip_join/data/repo/trip_join_repo_imp.dart';
import 'package:fourtyninehub/features/trip_join/domain/repo/trip_join_repo.dart';
import 'package:fourtyninehub/features/trip_join/domain/usecases/fetch_location_cordinates_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class TripJoinServiceLocator {
  static void execute({required GetIt serviceLocator}) {
    serviceLocator.registerLazySingleton<Dio>(
      () => Dio()
        ..interceptors.addAll([
          SubscriptionInterceptor(),
          if (kDebugMode)
            PrettyDioLogger(
              requestHeader: true,
              requestBody: true,
              responseBody: true,
              responseHeader: false,
              error: true,
              compact: true,
              maxWidth: 90,
            )
        ]),
      instanceName: 'dioGoogleApi',
    );

    serviceLocator.registerLazySingleton<GoogleApiConsumer>(
      () =>
          GoogleApiConsumer(dio: serviceLocator(instanceName: 'dioGoogleApi')),
    );

    serviceLocator.registerLazySingleton<FetchLocationRemoteDataSource>(
      () =>
          FetchLocationRemoteDataSourceImp(googleApiConsumer: serviceLocator()),
    );

    serviceLocator.registerLazySingleton<TripJoinRepo>(
      () => TripJoinRepoImp(fetchLocationRemoteDataSource: serviceLocator()),
    );

    serviceLocator.registerLazySingleton<FetchLocationCordinatesUseCase>(
      () => FetchLocationCordinatesUseCase(tripJoinRepo: serviceLocator()),
    );
  }
}
