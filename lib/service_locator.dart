import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/features/authentication/data/data_sources/remote_data_source/user_remote_data_source.dart';
import 'package:fourtyninehub/features/authentication/data/repositories/user_repository_impl.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/user_repository.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/attach_token_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_tokens_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_user_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/login_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/save_tokens_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/verify_otp_use_case.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/login_cubit/login_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/register_cubit/register_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/verify_otp_cubit/verify_otp_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'core/api/api_consumer.dart';
import 'core/local_storage/local_storage_consumer.dart';
import 'features/authentication/data/data_sources/local_data_source/auth_local_data_source.dart';
import 'features/authentication/data/data_sources/remote_data_source/auth_remote_data_source.dart';
import 'features/authentication/data/repositories/auth_repository_impl.dart';
import 'features/authentication/domain/repositories/auth_repository.dart';
import 'features/authentication/domain/use_cases/register_use_case.dart';
import 'features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'firebase_options.dart';

final serviceLocator = GetIt.instance;

class DI {
  static Future<void> execute() async {
    await Firebase.initializeApp(
      name: "49-App",
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
    FirebaseMessaging.instance.subscribeToTopic('all');

    serviceLocator.registerSingleton<LocalStorageConsumer>(
      const BaseLocalStorageConsumer(
        storage: FlutterSecureStorage(),
      ),
    );

    // dio
    serviceLocator.registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: kReleaseMode
              ? EndPoints.productionBaseUrl
              : EndPoints.developmentBaseUrl,
          connectTimeout: const Duration(seconds: 60),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      )..interceptors.addAll(
          [
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
          ],
        ),
    );

    // api consumer
    serviceLocator.registerLazySingleton<ApiConsumer>(
      () => BaseApiConsumer(
        serviceLocator(),
        //serviceLocator(),
      ),
    );

    // auth feature
    serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(
        serviceLocator(),
      ),
    );

    // auth cubits
    serviceLocator.registerFactory<LoginCubit>(
      () => LoginCubit(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<UserCubit>(
      () => UserCubit(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      )..attachToken(),
    );
    serviceLocator.registerFactory<RegisterCubit>(
      () => RegisterCubit(
        serviceLocator(),
      ),
    );
    serviceLocator.registerFactory<VerifyOtpCubit>(
      () => VerifyOtpCubit(
        serviceLocator(),
      ),
    );

    // auth use cases
    serviceLocator.registerFactory(() => LoginUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => GetUserUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => AttachTokenUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => SaveTokensUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => GetTokensUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => RegisterUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => VerifyOTPUseCase(serviceLocator()));
  }
}
