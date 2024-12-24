import 'package:firebase_auth/firebase_auth.dart';
import 'package:fourtyninehub/features/authentication/data/data_sources/remote_data_source/wallet_datasource.dart';
import 'package:fourtyninehub/features/authentication/data/repositories/wallet_repository.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/create_new_forget_password_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_welcome_gift_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/google_sign_in_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/resend_otp_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/send_forget_password_otp_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/verify_forget_password_otp_use_case.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/create_new_forgot_password_cubit/create_new_forgot_password_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/get_wallet_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/verify_forgot_password_otp/verify_forgot_password_otp_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
import '../features/authentication/domain/use_cases/sign_out_usecase.dart';
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
    serviceLocator.registerLazySingleton(
      () => WalletRepository(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton(
      () => WalletDataSource(
        serviceLocator(),
      ),
    );
    // auth use cases
    serviceLocator.registerFactory(() => LoginUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => GetUserUseCase(serviceLocator()));
    // serviceLocator.registerFactory<CacheService>(() => CacheServiceImpl());
    serviceLocator.registerFactory(() => AttachTokenUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => SaveTokensUseCase(serviceLocator()));
    // serviceLocator.registerFactory<CacheService>(() => CacheServiceImpl());
    serviceLocator.registerFactory(() => GetTokensUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => RegisterUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => VerifyOTPUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => ResendOTPUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => SignOutUseCase(serviceLocator()));
    serviceLocator
        .registerFactory(() => GetWelcomeGiftUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => GoogleSignInUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => AppleSignInUseCase(serviceLocator()));
    // serviceLocator
    //     .registerFactory(() => FacebookSignInUseCase(serviceLocator()));
    serviceLocator
        .registerFactory(() => SendForgetPasswordOTPUseCase(serviceLocator()));
    serviceLocator.registerFactory(
        () => VerifyForgetPasswordOTPUseCase(serviceLocator()));
    serviceLocator.registerFactory(
        () => CreateNewForgetPasswordUseCase(serviceLocator()));

    // auth cubits
    serviceLocator.registerFactory<LoginCubit>(
      () {
        final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
        final GoogleSignIn googleSignIn = GoogleSignIn();
        return LoginCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          googleSignIn: googleSignIn,
          firebaseAuth: firebaseAuth,
        );
      },
    );
    serviceLocator.registerSingleton(
      UserCubit(serviceLocator(), serviceLocator(), serviceLocator(),
          serviceLocator(), serviceLocator(), serviceLocator())
        ..attachToken(),
    );
    serviceLocator.registerSingleton(
      GetWalletCubit(
        serviceLocator(),
      )..getWallet(),
    );
    serviceLocator.registerFactory(
      () => ForgotPasswordCubit(
        serviceLocator(),
      ),
    );
    serviceLocator.registerFactory(
      () => VerifyForgotPasswordOtpCubit(
        serviceLocator(),
      ),
    );
    serviceLocator.registerFactory(
      () => CreateNewForgotPasswordCubit(
        serviceLocator(),
      ),
    );

    serviceLocator.registerFactory<RegisterCubit>(
      () => RegisterCubit(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
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
