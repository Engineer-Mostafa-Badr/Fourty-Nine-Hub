import 'package:dartz/dartz.dart';
import '../entities/currency_rates_entity.dart';
import '../repositories/currency_repository.dart';
import '../../../../core/error/failure.dart';

class GetExchangeRatesUseCase {
  final CurrencyRepository repository;

  GetExchangeRatesUseCase(this.repository);

  Future<Either<Failure, CurrencyRatesEntity>> call({
    required String code,
  }) {
    return repository.getExchangeRates(code: code);
  }
}