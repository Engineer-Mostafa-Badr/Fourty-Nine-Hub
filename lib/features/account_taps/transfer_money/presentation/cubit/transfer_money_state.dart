import '../../../../../core/enums/base_status_enum.dart';
import '../../../../../core/error/failure.dart';

class TransferMoneyState {
  final StateStatus status;
  final Failure? failure;

  const TransferMoneyState({
    this.status = StateStatus.loading,
    this.failure,
  });
  TransferMoneyState copyWith({
    StateStatus? status,
    Failure? failure,
  }) {
    return TransferMoneyState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}