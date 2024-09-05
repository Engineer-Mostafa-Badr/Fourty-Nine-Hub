
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/balance_data_entity.dart';

import '../../../../../../core/error/failure.dart';

enum BalanceStates { loading, initial, error }

class BalanceState {
  final BalanceStates status;
  final Failure? failure;
  final BalanceDataEntity? balance;

  const BalanceState({
    this.status = BalanceStates.loading,
    this.failure,
    this.balance,
  });
  BalanceState copyWith({
    BalanceStates? status,
    Failure? failure,
    BalanceDataEntity? balance,
  }) {
    return BalanceState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      balance: balance ?? this.balance,
    );
  }
}
