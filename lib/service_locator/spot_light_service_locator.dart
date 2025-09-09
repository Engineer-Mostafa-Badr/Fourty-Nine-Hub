import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/features/social_media/spot_light/data/data_source/spotlight_data_source.dart';
import 'package:fourtyninehub/features/social_media/spot_light/data/repos/spotlight_repo_impl.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/repos/spotlight_repo.dart';
import 'package:fourtyninehub/features/social_media/spot_light/presentation/logic/spot_light_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../core/data/datasources/remote/api/end_points.dart';
import '../core/data/datasources/remote/api/interceptors/subscription_interceptor.dart';

class SpotlightServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<Dio>(
          () => Dio(
        BaseOptions(
          baseUrl: kReleaseMode
              ? EndPoints.productionBaseUrl
              : EndPoints.developmentBaseUrl,
          connectTimeout: const Duration(seconds: 120), // longer for uploads
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
      )..interceptors.addAll([
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
      instanceName: "uploadDio",
    );

    // Register Spotlight Data Source
    serviceLocator.registerLazySingleton<SpotlightDataSource>(
          () => SpotlightDataSourceImpl(
        uploadDio: serviceLocator<Dio>(instanceName: "uploadDio"),
            api: serviceLocator<ApiConsumer>(),
      ),
    );


    // Register Spotlight Repository
    serviceLocator.registerLazySingleton<SpotlightRepository>(
      () => SpotlightRepositoryImpl(
        dataSource: serviceLocator<SpotlightDataSource>(),
      ),
    );

    // Register Spotlight Cubit
    serviceLocator.registerFactory<SpotlightCubit>(
      () => SpotlightCubit(
        repository: serviceLocator<SpotlightRepository>(),
      ),
    );
  }
}
