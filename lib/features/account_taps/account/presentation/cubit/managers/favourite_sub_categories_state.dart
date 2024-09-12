part of 'favourite_subcategories_cubit.dart';


class FavouriteSubCategoryState {
  final StateStatus status;
  final Failure? failure;
  final List<FavouriteCategoryEntity>? data;
  const FavouriteSubCategoryState({
    this.status = StateStatus.loading,
    this.failure,
    this.data  });
  FavouriteSubCategoryState copyWith({
    StateStatus? status,
    Failure? failure,
    List<FavouriteCategoryEntity>? data
  }) {
    return FavouriteSubCategoryState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      data: data ?? this.data,
    );
  }
}
