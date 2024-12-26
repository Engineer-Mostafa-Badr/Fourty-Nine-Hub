part of 'favourite_categories_cubit.dart';

class FavouriteCategoryState {
  final StateStatus status;
  final Failure? failure;
  final List<MainCategoryEntity>? data;
  const FavouriteCategoryState(
      {this.status = StateStatus.loading, this.failure, this.data});
  FavouriteCategoryState copyWith(
      {StateStatus? status, Failure? failure, List<MainCategoryEntity>? data}) {
    return FavouriteCategoryState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      data: data ?? this.data,
    );
  }
}
