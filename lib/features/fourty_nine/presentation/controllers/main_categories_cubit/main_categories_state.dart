part of 'main_categories_cubit.dart';

class MainCategoriesState {
  final StateStatus status;
  final Failure? failure;
  final int selectedIndex;
  final GiftEntity? gift;
  final WalletEntity? wallet;
  final BalanceDataEntity? balance;
  final List<MainCategoryEntity>? data;
  MainCategoriesState(
      {this.status = StateStatus.initial,
      this.failure,
      this.selectedIndex = 0,
      this.data,
      this.wallet,
      this.balance,
      this.gift});

  MainCategoriesState copyWith(
      {StateStatus? status,
      Failure? failure,
      int? selectedIndex,
      GiftEntity? gift,
      WalletEntity? wallet,
      BalanceDataEntity? balance,
      List<MainCategoryEntity>? data}) {
    return MainCategoriesState(
        status: status ?? this.status,
        failure: failure ?? this.failure,
        selectedIndex: selectedIndex ?? this.selectedIndex,
        data: data ?? this.data,
        wallet: wallet ?? this.wallet,
        balance: balance ?? this.balance,
        gift: gift ?? this.gift);
  }
}
