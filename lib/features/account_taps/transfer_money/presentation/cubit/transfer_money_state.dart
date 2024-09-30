import '../../../../../core/enums/base_status_enum.dart';
import '../../../../../core/error/failure.dart';
import '../../../wallet/domain/entities/wallet/wallet_entity.dart';
import '../../domain/entities/user_transfer_money_entity.dart';

class TransferMoneyState {
  final StateStatus status;
  final Failure? failure;
  final List<UserTransferMoneyEntity>? users;
  final WalletEntity? wallet;

  const TransferMoneyState({
    this.status = StateStatus.loading,
    this.failure,
    this.users,
    this.wallet,
  });
  TransferMoneyState copyWith({
    StateStatus? status,
    Failure? failure,
    List<UserTransferMoneyEntity>? users,
    WalletEntity? wallet,
  }) {
    return TransferMoneyState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      users: users ?? this.users,
      wallet: wallet ?? this.wallet,
    );
  }
}
