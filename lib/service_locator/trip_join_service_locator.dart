import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fourtyninehub/core/api/google_api_consumer.dart';
import 'package:fourtyninehub/core/api/interceptors/subscription_interceptor.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/data/remote_data_source/fetch_location_remote_datasource.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/data/remote_data_source/trip_join_remote_datasource.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/data/repo/trip_join_google_api_repo_imp.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/data/repo/trip_join_repo_imp.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/repo/trip_join_google_api_repo.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/repo/trip_join_repo.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/usecases/fetch_car_brand_usecase.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/usecases/fetch_car_model_usecase.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/usecases/fetch_car_year_type_usecase.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/usecases/fetch_location_cordinates_usecase.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/usecases/fetch_price_distance_usecase.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/usecases/publish_trip_join_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class TripJoinServiceLocator {
  //! google api db injection
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
      () => GoogleApiConsumer(dio: serviceLocator(instanceName: 'dioGoogleApi')),
    );

    serviceLocator.registerLazySingleton<FetchLocationRemoteDataSource>(
      () => FetchLocationRemoteDataSourceImp(googleApiConsumer: serviceLocator()),
    );

    serviceLocator.registerLazySingleton<TripJoinGoogleApiRepo>(
      () => TripJoinGoogleApiRepoImp(fetchLocationRemoteDataSource: serviceLocator()),
    );

    serviceLocator.registerLazySingleton<FetchLocationCordinatesUseCase>(
      () => FetchLocationCordinatesUseCase(tripJoinGoogleApiRepo: serviceLocator()),
    );

    //! trip join db injection
    serviceLocator.registerLazySingleton<TripJoinRemoteDataSource>(
      () => TripJoinRemoteDataSourceImp(apiConsumer: serviceLocator()),
    );

    serviceLocator.registerLazySingleton<TripJoinRepo>(
      () => TripJoinRepoImp(tripJoinRemoteDataSource: serviceLocator()),
    );

    serviceLocator.registerLazySingleton<FetchPriceDistanceUsecase>(
      () => FetchPriceDistanceUsecase(tripJoinRepo: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<FetchCarBrandUseCase>(
      () => FetchCarBrandUseCase(tripJoinRepo: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<FetchCarModelUseCase>(
      () => FetchCarModelUseCase(tripJoinRepo: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<FetchCarYearTypeUseCase>(
      () => FetchCarYearTypeUseCase(tripJoinRepo: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<PublishTripJoinUseCase>(
      () => PublishTripJoinUseCase(tripJoinRepo: serviceLocator()),
    );
  }
}
