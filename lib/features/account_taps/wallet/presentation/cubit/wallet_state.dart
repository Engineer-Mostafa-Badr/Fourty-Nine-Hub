part of 'wallet_cubit.dart';

enum WalletStates { loading, initial, error }

class WalletState {
  final WalletStates status;
  final Failure? failure;
  final WalletEntity? wallet;
  final List<WalletHistoryEntity>? history;

  const WalletState({
    this.status = WalletStates.loading,
    this.failure,
    this.history,
    this.wallet,
  });
  WalletState copyWith({
    WalletStates? status,
    Failure? failure,
    List<WalletHistoryEntity>? history,
    WalletEntity? wallet
  }) {
    return WalletState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      history: history ?? this.history,
      wallet: wallet ?? this.wallet,
    );
  }
}
