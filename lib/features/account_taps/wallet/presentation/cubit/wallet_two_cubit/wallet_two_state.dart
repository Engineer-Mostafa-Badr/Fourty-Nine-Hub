part of 'wallet_two_cubit.dart';

sealed class WalletTwoState extends Equatable {
  const WalletTwoState();

  @override
  List<Object> get props => [];
}

final class WalletTwoInitial extends WalletTwoState {}

final class WalletTwoLoading extends WalletTwoState {}

final class WalletTwoSuccess extends WalletTwoState {
  final WalletEntity wallet;
  final List<WalletHistoryEntity>? walletHistory;
  final List<WalletSubscriptionEntity>? subscription;
  final List<MainCategoryWalletEntity> mainCategory;
  // final List<MainCategoryWalletEntity>? subCategory;

  const WalletTwoSuccess({
    required this.wallet,
    required this.walletHistory,
    required this.subscription,
    required this.mainCategory,
    // required this.subCategory,
  });
}

final class WalletTwoError extends WalletTwoState {
  final Failure failure;

  const WalletTwoError({required this.failure});
}

// final class WalletHistorySuccess extends WalletTwoState {
//   final List<WalletHistoryEntity> histories;

//   const WalletHistorySuccess({required this.histories});
// }

// final class WalletSubscriptionSuccess extends WalletTwoState {
//   final List<WalletSubscriptionEntity> subscriptions;

//   const WalletSubscriptionSuccess({required this.subscriptions});
// }

// final class WalletMainCategorySuccess extends WalletTwoState {
//   final List<MainCategoryWalletEntity> mainCategories;

//   const WalletMainCategorySuccess({required this.mainCategories});
// }
