import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/toggle_favorite_category.dart';
import '../../../../../fourty_nine/domain/use_cases/remove_main_category_to_favorites_usecase.dart';
import '../../../data/models/favouite_category_model/favouite_category_model.dart';
import '../../../domain/usecases/get_favourite_categories_usecase.dart';

part 'favourite_categories_state.dart';

class FavouriteCategoryCubit extends Cubit<FavouriteCategoryState> {
  final GetFavouriteCategoriesUseCase _getMainCategoriesUseCase;
  final ToggleFavoriteCategoryUseCase _toggleFavoriteCategoryUseCase;
  final RemoveMainCategoryFromFavoritesUseCase _removeMainCategoryFromFavoritesUseCase;

  FavouriteCategoryCubit(
      this._getMainCategoriesUseCase, this._toggleFavoriteCategoryUseCase, this._removeMainCategoryFromFavoritesUseCase)
      : super(
          const FavouriteCategoryState(),
        );

  void loadData() async {
    print("=====================object");
    emit(state.copyWith(status: StateStatus.loading));
    final result = await _getMainCategoriesUseCase.call(const NoParams());
    log(result.toString(), name: "kljjjjjjjjjjjjjjjjjjjjjjjjj");
    emit(
      result.fold(
        (failure) => state.copyWith(
          failure: failure,
          status: StateStatus.error,
        ),
        (data) => state.copyWith(
          status: StateStatus.success,
          data: data,
        ),
      ),
    );
  }

  Future<bool> removeFavorite(String subcategoryId) async {
    final response = await _toggleFavoriteCategoryUseCase(subcategoryId);
    bool result = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (data) {
      result = data;
      emit(state.copyWith(status: StateStatus.success));
    });
    return result;
  }
  Future<bool> removeFavoriteCategory(String categoryId) async {
    final response = await _removeMainCategoryFromFavoritesUseCase(categoryId);
    bool result = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (data) {
      result = data;
      emit(state.copyWith(status: StateStatus.success));
    });
    return result;
  }
}
