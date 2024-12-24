part of 'main_categories_cubit.dart';

class MainCategoriesState {
  final StateStatus status;
  final Failure? failure;
  final int selectedIndex;
  final CurrencyEntity? currency;
  final List<MainCategoryEntity>? data;
  final List<MainCategoryEntity>? customPage;
  final WalletHomeEntity? wallet;
  MainCategoriesState({
    this.status = StateStatus.initial,
    this.failure,
    this.currency,
    this.selectedIndex = 0,
    this.data,
    this.customPage,
    this.wallet,
  });

  MainCategoriesState copyWith(
      {StateStatus? status,
      Failure? failure,
      int? selectedIndex,
      CurrencyEntity? currency,
      WalletHomeEntity? wallet,
      List<MainCategoryEntity>? data,
      List<MainCategoryEntity>? customPage,
      }) {
    return MainCategoriesState(
      status: status ?? this.status,
      currency: currency ?? this.currency,
      failure: failure ?? this.failure,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      data: data ?? this.data,
      customPage: customPage ?? this.customPage,
      wallet: wallet ?? this.wallet,
    );
  }
}
