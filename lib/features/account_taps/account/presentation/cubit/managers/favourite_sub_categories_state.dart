part of 'favourite_subcategories_cubit.dart';

class FavouriteSubCategoryState {
  final StateStatus status;
  final Failure? failure;
  final List<FavouriteSubcategoryEntity>? data;
  final List<MainCategoryEntity>? mainCategory;
  const FavouriteSubCategoryState(
      {this.status = StateStatus.loading,
      this.failure,
      this.data,
      this.mainCategory});
  FavouriteSubCategoryState copyWith(
      {StateStatus? status,
      Failure? failure,
      List<FavouriteSubcategoryEntity>? data,
      List<MainCategoryEntity>? mainCategory}) {
    return FavouriteSubCategoryState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      data: data ?? this.data,
      mainCategory: mainCategory ?? this.mainCategory,
    );
  }
}
