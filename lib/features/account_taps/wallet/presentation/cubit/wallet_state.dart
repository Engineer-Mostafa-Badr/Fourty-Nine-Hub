import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/main_category_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_history_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_subscription_entity.dart';

enum WalletStates { loading, initial, error }

class WalletState {
  final WalletStates status;
  final Failure? failure;
  final WalletEntity? wallet;
  final WalletTypes? selectedWallet;
  final List<WalletHistoryEntity>? history;
  final List<WalletSubscriptionEntity>? subscription;
  final List<MainCategoryWalletEntity>? mainCategory;

  const WalletState({
    this.status = WalletStates.loading,
    this.failure,
    this.history,
    this.wallet,
    this.selectedWallet,
    this.subscription,
    this.mainCategory,
  });

  WalletState copyWith({
    WalletStates? status,
    Failure? failure,
    List<WalletHistoryEntity>? history,
    WalletEntity? wallet,
    WalletTypes? selectedWallet,
    List<WalletSubscriptionEntity>? subscription,
    List<MainCategoryWalletEntity>? mainCategory,
  }) {
    return WalletState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      history: history ?? this.history,
      wallet: wallet ?? this.wallet,
      selectedWallet: selectedWallet ?? this.selectedWallet,
      subscription: subscription ?? this.subscription,
      mainCategory: mainCategory ?? this.mainCategory,
    );
  }
}
