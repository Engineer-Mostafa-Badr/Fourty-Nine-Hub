import 'package:dartz/dartz.dart';
import '../entities/exchange_rate_entity.dart';
import '../repositories/currency_repository.dart';
import '../../../../core/error/failure.dart';

class ConvertCurrencyUseCase {
  final CurrencyRepository repository;

  ConvertCurrencyUseCase(this.repository);

  Future<Either<Failure, ExchangeRateEntity>> call({
    required String from,
    required String to,
    required double amount,
  }) {
    return repository.convertCurrency(from: from, to: to, amount: amount);
  }
}