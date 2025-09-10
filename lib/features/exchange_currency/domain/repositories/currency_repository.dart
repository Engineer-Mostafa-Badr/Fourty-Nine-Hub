import 'package:dartz/dartz.dart';
import '../entities/exchange_rate_entity.dart';
import '../entities/currency_rates_entity.dart';
import '../../../../core/error/failure.dart';

abstract class CurrencyRepository {
  Future<Either<Failure, ExchangeRateEntity>> convertCurrency({
    required String from,
    required String to,
    required double amount,
  });

  Future<Either<Failure, CurrencyRatesEntity>> getExchangeRates({
    required String code,
  });
}