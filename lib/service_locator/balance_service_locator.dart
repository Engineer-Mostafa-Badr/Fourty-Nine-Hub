import 'package:fourtyninehub/features/account_taps/wallet/data/datasources/balance/balance_remote_data_source.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/repositories/balance_repository_impl.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/repositories/balance_repository.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_balance_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Balance_Cubit/balance_cubit.dart';
import 'package:get_it/get_it.dart';

import '../features/account_taps/wallet/domain/usecases/get_balance_history_use_case.dart';
import '../features/account_taps/wallet/domain/usecases/transfer_balance_use_cse.dart';
import '../features/account_taps/wallet/domain/usecases/transfer_ten_balance_use_cse.dart';
import '../features/account_taps/wallet/domain/usecases/withdraw_balance_use_cse.dart';

class BalanceServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<BalanceRemoteDataSource>(
        () => BalanceRemoteDataSourceImpl(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<BalanceRepository>(() => BalanceRepositoryImpl(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<GetBalanceUseCases>(() => GetBalanceUseCases(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<GetBalanceHistoryUseCase>(
        () => GetBalanceHistoryUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<TransferFiveBalanceUseCase>(
        () => TransferFiveBalanceUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<TransferTenBalanceUseCase>(
        () => TransferTenBalanceUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<RequestWithdrawBalanceUseCase>(
        () => RequestWithdrawBalanceUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerFactory<BalanceCubit>(
        () => BalanceCubit(
            serviceLocator(),
            serviceLocator(),
            serviceLocator(),
            serviceLocator(),
            serviceLocator(),
        )..loadData());
  }
}
