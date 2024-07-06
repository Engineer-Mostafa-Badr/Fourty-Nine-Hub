part of 'wallet_cubit.dart';

enum WalletStates { loading, initial, error }

class WalletState {
  final WalletStates status;
  final Failure? failure;
  final List<WalletHistoryEntity>? balanceHistory;
  final List<WalletHistoryEntity>? walletHistory;
  final List<CompetitionEntity>? competitions;
  const WalletState({
    this.status = WalletStates.loading,
    this.failure,
    this.balanceHistory,
    this.walletHistory,
    this.competitions,
  });
  WalletState copyWith({
    WalletStates? status,
    Failure? failure,
    List<WalletHistoryEntity>? balanceHistory,
    List<WalletHistoryEntity>? walletHistory,
    List<CompetitionEntity>? competitions,
  }) {
    return WalletState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      balanceHistory: balanceHistory ?? this.balanceHistory,
      walletHistory: walletHistory ?? this.walletHistory,
      competitions: competitions ?? this.competitions,
    );
  }
}
