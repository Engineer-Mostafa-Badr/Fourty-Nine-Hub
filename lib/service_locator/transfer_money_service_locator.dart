import 'package:fourtyninehub/features/account_taps/transfer_money/domain/use_case/transfer_money_use_case.dart';
import 'package:get_it/get_it.dart';
import '../features/account_taps/transfer_money/data/data_source/transfer_money_remote_data_source.dart';
import '../features/account_taps/transfer_money/data/repository/transfer_money_repository_impl.dart';
import '../features/account_taps/transfer_money/domain/repository/transfer_money_repository.dart';
import '../features/account_taps/transfer_money/presentation/cubit/transfer_money_cubit.dart';

class TransferMoneyServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<TransferMoneyRemoteDataSource>(
            () => TransferMoneyRemoteDataSourceImpl(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<TransferMoneyRepository>(
            () => TransferMoneyRepositoryImpl(serviceLocator()));

    serviceLocator
        .registerLazySingleton<TransferMoneyUseCase>(() => TransferMoneyUseCase(
      serviceLocator(),
    ));

    serviceLocator.registerFactory<TransferMoneyCubit>(
            () => TransferMoneyCubit(
          serviceLocator(),
        ));
  }
}
