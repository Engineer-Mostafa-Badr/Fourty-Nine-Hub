part of 'get_currency_cubit.dart';

sealed class GetCurrencyState {
  const GetCurrencyState();
}

final class GetCurrencyInitial extends GetCurrencyState {}

final class GetCurrencySuccess extends GetCurrencyState {
  final String currency;

  const GetCurrencySuccess(this.currency);
}

final class GetCurrencyLoading extends GetCurrencyState {}

final class GetCurrencyFailure extends GetCurrencyState {
  final String errorMessage;

  GetCurrencyFailure(this.errorMessage);
}
