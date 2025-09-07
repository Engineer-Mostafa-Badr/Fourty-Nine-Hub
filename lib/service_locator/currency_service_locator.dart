import 'package:get_it/get_it.dart';

import '../features/exchange_currency/data/datasources/currency_remote_datasource.dart';
import '../features/exchange_currency/data/repositories/currency_repository_impl.dart';
import '../features/exchange_currency/domain/repositories/currency_repository.dart';
import '../features/exchange_currency/domain/usecases/convert_currency_usecase.dart';
import '../features/exchange_currency/domain/usecases/get_exchange_rates_usecase.dart';
import '../features/exchange_currency/presentation/logic/currency_cubit.dart';

class CurrencyServiceLocator {
  static void execute({required GetIt serviceLocator}) {
    // Data Sources
    serviceLocator.registerLazySingleton<CurrencyRemoteDataSource>(
      () => CurrencyRemoteDataSourceImpl(serviceLocator()),
    );

    // Repositories
    serviceLocator.registerLazySingleton<CurrencyRepository>(
      () => CurrencyRepositoryImpl(serviceLocator()),
    );

    // Use Cases
    serviceLocator.registerLazySingleton<ConvertCurrencyUseCase>(
      () => ConvertCurrencyUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<GetExchangeRatesUseCase>(
      () => GetExchangeRatesUseCase(serviceLocator()),
    );

    // Cubit
    serviceLocator.registerFactory<CurrencyCubit>(
      () => CurrencyCubit(
        convertCurrencyUseCase: serviceLocator(),
        getExchangeRatesUseCase: serviceLocator(),
      ),
    );
  }
}