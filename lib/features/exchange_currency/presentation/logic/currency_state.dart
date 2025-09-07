part of 'currency_cubit.dart';

abstract class CurrencyState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CurrencyInitial extends CurrencyState {}

class CurrencyLoading extends CurrencyState {}

class CurrencyConverted extends CurrencyState {
  final ExchangeRateEntity exchangeRate;

  CurrencyConverted(this.exchangeRate);

  @override
  List<Object?> get props => [exchangeRate];
}

class CurrencyRatesLoaded extends CurrencyState {
  final CurrencyRatesEntity currencyRates;

  CurrencyRatesLoaded(this.currencyRates);

  @override
  List<Object?> get props => [currencyRates];
}

class CurrencyError extends CurrencyState {
  final String message;

  CurrencyError(this.message);

  @override
  List<Object?> get props => [message];
}