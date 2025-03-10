part of 'charge_wallet_cubit.dart';

sealed class ChargeWalletState extends Equatable {
  const ChargeWalletState();

  @override
  List<Object> get props => [];
}

final class ChargeWalletInitial extends ChargeWalletState {}

final class ChargeWalletLoading extends ChargeWalletState {}

final class ChargeWalletSuccess extends ChargeWalletState {
  final List<SubscriptionAmountEntity> amounts;

  const ChargeWalletSuccess({required this.amounts});
}

final class ChargeWalletFailure extends ChargeWalletState {
  final String message;

  const ChargeWalletFailure({required this.message});
}
