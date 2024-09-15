import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/entities/favourite_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/toggle_favorite_category.dart';
import '../../../domain/usecases/get_favourite_categories_usecase.dart';

part 'favourite_categories_state.dart';

class FavouriteCategoryCubit extends Cubit<FavouriteCategoryState> {
  final GetFavouriteCategoriesUseCase _getMainCategoriesUseCase;
  final ToggleFavoriteCategoryUseCase _toggleFavoriteCategoryUseCase;

  FavouriteCategoryCubit(
      this._getMainCategoriesUseCase, this._toggleFavoriteCategoryUseCase)
      : super(
          const FavouriteCategoryState(),
        );

  void loadData() async {
    print("=====================object");
    emit(state.copyWith(status: StateStatus.loading));
    final result = await _getMainCategoriesUseCase.call(const NoParams());
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
}
