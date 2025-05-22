part of 'wallet_two_cubit.dart';

enum WalletTwoStates { loading, initial, failure, success }

extension WalletTwoStateX on WalletTwoStates {
  bool get isInitial => this == WalletTwoStates.initial;
  bool get isLoading => this == WalletTwoStates.loading;
  bool get isSuccess => this == WalletTwoStates.success;
  bool get isFailure => this == WalletTwoStates.failure;
}

class WalletTwoState {
  final WalletTwoStates status;
  final WalletTwoStates historyStatus;
  final WalletEntity? wallet;
  final List<WalletHistoryEntity>? walletHistory;
  final int page;
  final bool hasReachedMax;
  final List<WalletSubscriptionEntity>? subscription;
  final List<MainCategoryWalletEntity>? mainCategory;
  final bool buttonRequestLoading;
  final bool? buttonRequestSuccess;
  final String? buttonRequestErrMessage;
  final String? failureMessage;
  final Failure? failureHistory;

  const WalletTwoState({
    this.status = WalletTwoStates.initial,
    this.historyStatus = WalletTwoStates.initial,
    this.wallet,
    this.walletHistory,
    this.page = 1,
    this.hasReachedMax = false,
    this.subscription,
    this.mainCategory,
    this.failureMessage,
    this.failureHistory,
    this.buttonRequestLoading = false,
    this.buttonRequestSuccess,
    this.buttonRequestErrMessage,
  });

  WalletTwoState copyWith({
    WalletTwoStates? status,
    WalletTwoStates? historyStatus,
    WalletEntity? wallet,
    List<WalletHistoryEntity>? walletHistory,
    int? page,
    bool? hasReachedMax,
    List<WalletSubscriptionEntity>? subscription,
    List<MainCategoryWalletEntity>? mainCategory,
    String? failureMessage,
    Failure? failureHistory,
    bool? buttonRequestLoading,
    bool? buttonRequestSuccess,
    String? buttonRequestErrMessage,
  }) {
    return WalletTwoState(
      status: status ?? this.status,
      historyStatus: historyStatus ?? this.historyStatus,
      wallet: wallet ?? this.wallet,
      walletHistory: walletHistory ?? this.walletHistory,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      subscription: subscription ?? this.subscription,
      mainCategory: mainCategory ?? this.mainCategory,
      failureMessage: failureMessage ?? this.failureMessage,
      failureHistory: failureHistory ?? this.failureHistory,
      buttonRequestLoading: buttonRequestLoading ?? this.buttonRequestLoading,
      buttonRequestSuccess: buttonRequestSuccess ?? this.buttonRequestSuccess,
      buttonRequestErrMessage:
          buttonRequestErrMessage ?? this.buttonRequestErrMessage,
    );
  }
}

// final class WalletTwoInitial extends WalletTwoState {}
//
// final class WalletTwoLoading extends WalletTwoState {}
//
// final class WalletTwoSuccess extends WalletTwoState {
//   // final List<MainCategoryWalletEntity>? subCategory;
//
//   const WalletTwoSuccess({
//     required this.wallet,
//     required this.walletHistory,
//     required this.subscription,
//     required this.mainCategory,
//     // required this.subCategory,
//   });
// }
//
// final class WalletTwoError extends WalletTwoState {
//   final Failure failure;
//
//   const WalletTwoError({required this.failure});
// }

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
