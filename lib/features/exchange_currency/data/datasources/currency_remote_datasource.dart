import 'package:dartz/dartz.dart';
import '../models/exchange_rate_model.dart';
import '../models/currency_rates_model.dart';
import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/error/failure.dart';

abstract class CurrencyRemoteDataSource {
  Future<Either<Failure, ExchangeRateModel>> convertCurrency({
    required String from,
    required String to,
    required double amount,
  });

  Future<Either<Failure, CurrencyRatesModel>> getExchangeRates({
    required String code,
  });
}

class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final ApiConsumer apiConsumer;

  CurrencyRemoteDataSourceImpl(this.apiConsumer);

  @override
  Future<Either<Failure, ExchangeRateModel>> convertCurrency({
    required String from,
    required String to,
    required double amount,
  }) async {
    try {
      final result = await apiConsumer.get(
        '/exchange-currency/pair/$from/$to/$amount',
      );

      return result.fold(
        (failure) => Left(failure),
        (response) {
          if (response['status'] == true && response['data'] != null) {
            return Right(ExchangeRateModel.fromJson(response['data']));
          } else {
            return Left(ServerFailure(
              message: 'Failed to convert currency',
              name: 'Conversion Error',
              statusCode: 400,
            ));
          }
        },
      );
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CurrencyRatesModel>> getExchangeRates({
    required String code,
  }) async {
    try {
      final result = await apiConsumer.get('/exchange-currency/$code');

      return result.fold(
        (failure) => Left(failure),
        (response) {
          if (response['status'] == true && response['data'] != null) {
            return Right(CurrencyRatesModel.fromJson(response['data']));
          } else {
            return Left(ServerFailure(
              message: 'Failed to get exchange rates',
              name: 'Exchange Rates Error',
              statusCode: 400,
            ));
          }
        },
      );
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
