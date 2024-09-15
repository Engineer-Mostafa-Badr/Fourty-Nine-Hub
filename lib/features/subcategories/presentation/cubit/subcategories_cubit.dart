import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/toggle_sub_category_to_favorites_usecase.dart';

import '../../domain/usecases/get_sub_categories_use_case.dart';
import '../../domain/entities/sub_category_entity.dart';

part 'subcategories_state.dart';

class SubcategoriesCubit extends Cubit<SubcategoriesState> {
  final GetSubCategoriesUseCase _getSubcategoriesUsecase;
  final ToggleSubCategoryToFavoritesUseCase
      _toggleSubCategoryToFavoritesUseCase;
  SubcategoriesCubit(
      this._getSubcategoriesUsecase, this._toggleSubCategoryToFavoritesUseCase)
      : super(const SubcategoriesState());

  String _mainCategoryId = '';

  init({required String mainCategoryId}) {
    _mainCategoryId = mainCategoryId;
  }

  Future<List<SubCategoryEntity>> getSubcategories(
      {required PaginationParams paginationParams}) async {
    List<SubCategoryEntity> data = [];
    emit(state.copyWith(status: SubcategoriesStates.loading));
    // await UserCubit.to.getUser();
    final user = UserCubit.to.state.data?.id;
    print('useeeerId===>$user}');
    final response = await _getSubcategoriesUsecase(GetSubCategoriesParams(
        mainCategoryId: _mainCategoryId,
        paginationParams: paginationParams,
        userId: user ?? ''));
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: SubcategoriesStates.error)),
        (r) => data = r);

    return data;
  }

  Future<bool> toggleSubCategoryToFavorites(String subcategoryId) async {
    final response = await _toggleSubCategoryToFavoritesUseCase(subcategoryId);
    bool result = false;
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: SubcategoriesStates.error)), (data) {
      result = data;
      emit(state.copyWith(status: SubcategoriesStates.initState));
    });
    return result;
  }
}
