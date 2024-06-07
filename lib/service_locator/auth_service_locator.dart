import 'package:fourtyninehub/features/authentication/domain/use_cases/facebook_sign_in_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_welcome_gift_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/google_sign_in_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/resend_otp_use_case.dart';
import 'package:get_it/get_it.dart';
import '../features/authentication/data/data_sources/local_data_source/auth_local_data_source.dart';
import '../features/authentication/data/data_sources/remote_data_source/auth_remote_data_source.dart';
import '../features/authentication/data/data_sources/remote_data_source/user_remote_data_source.dart';
import '../features/authentication/data/repositories/auth_repository_impl.dart';
import '../features/authentication/data/repositories/user_repository_impl.dart';
import '../features/authentication/domain/repositories/auth_repository.dart';
import '../features/authentication/domain/repositories/user_repository.dart';
import '../features/authentication/domain/use_cases/apple_sign_in_usecase.dart';
import '../features/authentication/domain/use_cases/attach_token_use_case.dart';
import '../features/authentication/domain/use_cases/get_tokens_use_case.dart';
import '../features/authentication/domain/use_cases/get_user_use_case.dart';
import '../features/authentication/domain/use_cases/login_use_case.dart';
import '../features/authentication/domain/use_cases/register_use_case.dart';
import '../features/authentication/domain/use_cases/save_tokens_use_case.dart';
import '../features/authentication/domain/use_cases/verify_otp_use_case.dart';
import '../features/authentication/presentation/controllers/login_cubit/login_cubit.dart';
import '../features/authentication/presentation/controllers/register_cubit/register_cubit.dart';
import '../features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../features/authentication/presentation/controllers/verify_otp_cubit/verify_otp_cubit.dart';

class AuthServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
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

    // auth use cases
    serviceLocator.registerFactory(() => LoginUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => GetUserUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => AttachTokenUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => SaveTokensUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => GetTokensUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => RegisterUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => VerifyOTPUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => ResendOTPUseCase(serviceLocator()));
    serviceLocator
        .registerFactory(() => GetWelcomeGiftUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => GoogleSignInUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => AppleSignInUseCase(serviceLocator()));
    serviceLocator
        .registerFactory(() => FacebookSignInUseCase(serviceLocator()));

    // auth cubits
    serviceLocator.registerFactory<LoginCubit>(
      () => LoginCubit(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    );
    serviceLocator.registerSingleton(
      UserCubit(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      )..attachToken(),
    );

    serviceLocator.registerFactory<RegisterCubit>(
      () => RegisterCubit(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      )..getWelcomeGift(),
    );
    serviceLocator.registerFactory<VerifyOtpCubit>(
      () => VerifyOtpCubit(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    );
  }
}
