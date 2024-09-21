part of 'main_categories_cubit.dart';

class MainCategoriesState {
  final StateStatus status;
  final Failure? failure;
  final int selectedIndex;
  final List<MainCategoryEntity>? data;
  final WalletHomeEntity? wallet;
  MainCategoriesState(
      {this.status = StateStatus.initial,
      this.failure,
      this.selectedIndex = 0,
      this.data,
      this.wallet,
   });

  MainCategoriesState copyWith(
      {StateStatus? status,
      Failure? failure,
      int? selectedIndex,
        WalletHomeEntity? wallet,
      List<MainCategoryEntity>? data}) {
    return MainCategoriesState(
        status: status ?? this.status,
        failure: failure ?? this.failure,
        selectedIndex: selectedIndex ?? this.selectedIndex,
        data: data ?? this.data,
        wallet: wallet ?? this.wallet,
       );
  }
}
