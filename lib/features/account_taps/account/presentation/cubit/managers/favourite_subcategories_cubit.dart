import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/entities/favourite_category_entity.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/usecases/get_favourite_subcategories_usecase.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/toggle_sub_category_to_favorites_usecase.dart';

import '../../../domain/entities/favourite_subcategory_entity.dart';

part 'favourite_sub_categories_state.dart';

class FavouriteSubCategoryCubit extends Cubit<FavouriteSubCategoryState> {
  final GetFavouriteSubCategoriesUseCase _getFavouriteSubCategoriesUseCase;
  final ToggleSubCategoryToFavoritesUseCase
      _toggleSubCategoryToFavoritesUseCase;

  FavouriteSubCategoryCubit(this._getFavouriteSubCategoriesUseCase,
      this._toggleSubCategoryToFavoritesUseCase)
      : super(
          const FavouriteSubCategoryState(),
        );

  void loadData() async {
    emit(state.copyWith(status: StateStatus.loading));
    final result =
        await _getFavouriteSubCategoriesUseCase.call(const NoParams());
    emit(
      result.fold(
        (failure) => state.copyWith(
          failure: failure,
          status: StateStatus.error,
        ),
        (data) => state.copyWith(
          status: StateStatus.success,
          // data: data,
        ),
      ),
    );
  }

  Future<List<FavouriteSubcategoryEntity>> getSubcategories(
      {required PaginationParams paginationParams}) async {
    List<FavouriteSubcategoryEntity> data = [];
    emit(state.copyWith(status: StateStatus.loading));
    // await UserCubit.to.getUser();
    final user = UserCubit.to.state.data?.id;
    print('useeeerId===>$user}');
    final response = await _getFavouriteSubCategoriesUseCase(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (r) => data = r);

    return data;
  }

  Future<bool> toggleSubCategoryToFavorites(String subcategoryId) async {
    final response = await _toggleSubCategoryToFavoritesUseCase(subcategoryId);
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
