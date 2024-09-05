import 'package:fourtyninehub/features/account_taps/wallet/data/datasources/balance/balance_remote_data_source.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/repositories/balance_repository_impl.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/repositories/balance_repository.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_balance_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Balance_Cubit/balance_cubit.dart';
import 'package:get_it/get_it.dart';

class BalanceServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {

    serviceLocator.registerLazySingleton<BalanceRemoteDataSource>(() => BalanceRemoteDataSourceImpl(
      serviceLocator(),
    ));

    serviceLocator.registerLazySingleton<BalanceRepository>(() => BalanceRepositoryImpl(serviceLocator()));

    serviceLocator.registerLazySingleton<GetBalanceUseCases>(() => GetBalanceUseCases(
      serviceLocator(),
    ));

    serviceLocator.registerFactory<BalanceCubit>(() => BalanceCubit(
      serviceLocator()
    )..loadData());

  }
}
