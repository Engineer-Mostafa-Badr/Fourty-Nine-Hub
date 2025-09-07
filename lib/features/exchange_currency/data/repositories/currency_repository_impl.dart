import 'package:dartz/dartz.dart';
import '../../domain/entities/exchange_rate_entity.dart';
import '../../domain/entities/currency_rates_entity.dart';
import '../../domain/repositories/currency_repository.dart';
import '../datasources/currency_remote_datasource.dart';
import '../../../../core/error/failure.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;

  CurrencyRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ExchangeRateEntity>> convertCurrency({
    required String from,
    required String to,
    required double amount,
  }) {
    return remoteDataSource.convertCurrency(from: from, to: to, amount: amount);
  }

  @override
  Future<Either<Failure, CurrencyRatesEntity>> getExchangeRates({
    required String code,
  }) {
    return remoteDataSource.getExchangeRates(code: code);
  }
}