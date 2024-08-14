part of 'main_categories_taps_cubit.dart';

class MainCategoriesTapsState {
  final StateStatus status;
  final Failure? failure;
  final int selectedIndex;
  final List<SubCategoryEntity>? subCategories;

  MainCategoriesTapsState(
      {this.status = StateStatus.initial,
      this.failure,
      this.selectedIndex = 0,
      this.subCategories});

  MainCategoriesTapsState copyWith(
      {StateStatus? status,
      Failure? failure,
      int? selectedIndex,
      List<SubCategoryEntity>? subCategories}) {
    return MainCategoriesTapsState(
        status: status ?? this.status,
        failure: failure ?? this.failure,
        selectedIndex: selectedIndex ?? this.selectedIndex,
        subCategories: subCategories ?? this.subCategories);
  }
}
