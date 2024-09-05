part of 'wallet_cubit.dart';

enum WalletStates { loading, initial, error }

class WalletState {
  final WalletStates status;
  final Failure? failure;
 // final List<WalletHistoryEntity>? balanceHistory;
  final WalletEntity? wallet;
 // final List<CompetitionEntity>? competitions;
  const WalletState({
    this.status = WalletStates.loading,
    this.failure,
 //   this.balanceHistory,
    this.wallet,
  //  this.competitions,
  });
  WalletState copyWith({
    WalletStates? status,
    Failure? failure,
   // List<WalletHistoryEntity>? balanceHistory,
    WalletEntity? wallet
   // List<CompetitionEntity>? competitions,
  }) {
    return WalletState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
    //  balanceHistory: balanceHistory ?? this.balanceHistory,
      wallet: wallet ?? this.wallet,
   //   competitions: competitions ?? this.competitions,
    );
  }
}
