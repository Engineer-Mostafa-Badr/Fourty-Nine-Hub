import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/balance/balance_data_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/balance/balance_history_entity.dart';

import '../../../../../../core/error/failure.dart';
import '../../../domain/entities/balance/request_withdraw_entity.dart';

enum BalanceStates { loading, initial, error,errorRequest, successFive, successTen ,success}

extension BalanceStatesX on BalanceState {
  bool get isInitial => status == BalanceStates.initial;
  bool get isLoading => status == BalanceStates.loading;
  bool get isError => status == BalanceStates.error;
  bool get isErrorRequest => status == BalanceStates.errorRequest;
  bool get isSuccessFive => status == BalanceStates.successFive;
  bool get isSuccessTen => status == BalanceStates.successTen;
  bool get isSuccess => status == BalanceStates.success;
}

class BalanceState {
  final BalanceStates status;
  final Failure? failure;
  final BalanceDataEntity? balance;
  final List<BalanceHistoryEntity>? history;
  final RequestWithdrawEntity? withdraw;

  const BalanceState({
    this.status = BalanceStates.loading,
    this.failure,
    this.balance,
    this.history,
    this.withdraw,
  });
  BalanceState copyWith(
      {BalanceStates? status,
      Failure? failure,
      BalanceDataEntity? balance,
      List<BalanceHistoryEntity>? history,
      RequestWithdrawEntity? withdraw}) {
    return BalanceState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      balance: balance ?? this.balance,
      history: history ?? this.history,
      withdraw: withdraw ?? this.withdraw,
    );
  }
}
