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

// Auto-refresh states
class CurrencyRefreshing extends CurrencyState {}

class CurrencyRefreshed extends CurrencyState {}

class CurrencyAutoRefreshEnabled extends CurrencyState {}

class CurrencyAutoRefreshDisabled extends CurrencyState {}

class CurrencyAutoRefreshFailed extends CurrencyState {
  final String message;

  CurrencyAutoRefreshFailed(this.message);

  @override
  List<Object?> get props => [message];
}

class CurrencyRefreshIntervalChanged extends CurrencyState {
  final Duration interval;

  CurrencyRefreshIntervalChanged(this.interval);

  @override
  List<Object?> get props => [interval];
}

// Silent update states
class CurrencyUpdatedSilently extends CurrencyState {
  final ExchangeRateEntity exchangeRate;

  CurrencyUpdatedSilently(this.exchangeRate);

  @override
  List<Object?> get props => [exchangeRate];
}

class CurrencyRatesUpdatedSilently extends CurrencyState {
  final CurrencyRatesEntity currencyRates;

  CurrencyRatesUpdatedSilently(this.currencyRates);

  @override
  List<Object?> get props => [currencyRates];
}

// Currency change states
class CurrencyFromChanged extends CurrencyState {
  final String currency;

  CurrencyFromChanged(this.currency);

  @override
  List<Object?> get props => [currency];
}

class CurrencyToChanged extends CurrencyState {
  final String currency;

  CurrencyToChanged(this.currency);

  @override
  List<Object?> get props => [currency];
}

class CurrenciesSwapped extends CurrencyState {
  final String fromCurrency;
  final String toCurrency;

  CurrenciesSwapped(this.fromCurrency, this.toCurrency);

  @override
  List<Object?> get props => [fromCurrency, toCurrency];
}
