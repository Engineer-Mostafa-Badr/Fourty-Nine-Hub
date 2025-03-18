part of 'subscription_wallet_cubit.dart';

@immutable
sealed class SubscriptionWalletState {}

final class SubscriptionWalletInitial extends SubscriptionWalletState {}

final class SubscriptionWalletLoading extends SubscriptionWalletState {}

final class SubscriptionWalletSuccess extends SubscriptionWalletState {}

final class SubscriptionWalletFailure extends SubscriptionWalletState {
  final String message;

   SubscriptionWalletFailure({required this.message});
}