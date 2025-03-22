import 'package:fourtyninehub/features/account_taps/transfer_money/domain/entities/transfer_money_entity.dart';

import '../../../../../core/error/failure.dart';
import '../../../wallet/domain/entities/wallet/wallet_entity.dart';
import '../../domain/entities/user_transfer_money_entity.dart';

enum TransferMoneyStates {
  initial,
  loading,
  error,
  success,
  transferLoading,
  transferSuccess,
  transferError
}

extension TransferMoneyStatesX on TransferMoneyState {
  bool get isInitial => status == TransferMoneyStates.initial;
  bool get isLoading => status == TransferMoneyStates.loading;
  bool get isError => status == TransferMoneyStates.error;
  bool get isSuccess => status == TransferMoneyStates.success;
  bool get isTransferLoading => status == TransferMoneyStates.transferLoading;
  bool get isTransferSuccess => status == TransferMoneyStates.transferSuccess;
  bool get isTransferError => status == TransferMoneyStates.transferError;
}

class TransferMoneyState {
  final TransferMoneyStates status;
  final Failure? failure;
  final List<UserTransferMoneyEntity>? users;
  final WalletEntity? wallet;
  final TransferMoneyEntity? dataTransfer;

  const TransferMoneyState({
    this.status = TransferMoneyStates.loading,
    this.failure,
    this.users,
    this.wallet,
    this.dataTransfer,
  });
  TransferMoneyState copyWith({
    TransferMoneyStates? status,
    Failure? failure,
    List<UserTransferMoneyEntity>? users,
    WalletEntity? wallet,
    TransferMoneyEntity? dataTransfer,
  }) {
    return TransferMoneyState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      users: users ?? this.users,
      wallet: wallet ?? this.wallet,
      dataTransfer: dataTransfer ?? this.dataTransfer,
    );
  }
}
