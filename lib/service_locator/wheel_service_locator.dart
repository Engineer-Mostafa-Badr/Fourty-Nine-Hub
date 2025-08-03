import '../features/lucky_wheel/data/data_sources/wheel_remote_data_source.dart';
import '../features/lucky_wheel/data/repositories/wheel_repository_impl.dart';
import '../features/lucky_wheel/domain/repositories/wheel_repository.dart';
import '../features/lucky_wheel/domain/use_cases/get_wheel_use_case.dart';
import '../features/lucky_wheel/domain/use_cases/get_wheel_wallet_use_case.dart';
import '../features/lucky_wheel/domain/use_cases/spin_wheel_use_case.dart';
import '../features/lucky_wheel/presentation/controllers/spin_wheel_cubit/spin_wheel_cubit.dart';
import '../features/lucky_wheel/presentation/controllers/wheel_cubit/wheel_cubit.dart';
import '../features/lucky_wheel/presentation/controllers/wheel_wallet_cubit/wheel_wallet_cubit.dart';
import 'package:get_it/get_it.dart';

class WheelServiceLocator {
  static void execute(GetIt serviceLocator) {
    serviceLocator.registerLazySingleton<WheelRemoteDataSource>(
      () => WheelRemoteDataSourceImpl(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<WheelRepository>(
      () => WheelRepositoryImpl(
        serviceLocator(),
      ),
    );

    // use cases
    serviceLocator.registerLazySingleton<GetWheelUseCase>(
      () => GetWheelUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<SpinWheelUseCase>(
      () => SpinWheelUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetWheelWalletUseCase>(
      () => GetWheelWalletUseCase(
        serviceLocator(),
      ),
    );

    // cubits
    serviceLocator.registerFactory<WheelCubit>(
      () => WheelCubit(
        serviceLocator(),
      )..getWheel(),
    );

    serviceLocator.registerFactory<WheelWalletCubit>(
      () => WheelWalletCubit(
        serviceLocator(),
      )..getWheelWallet(),
    );

    serviceLocator.registerFactory<SpinWheelCubit>(
      () => SpinWheelCubit(
        serviceLocator(),
      ),
    );
  }
}
