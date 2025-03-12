import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/toggle_sub_category_to_favorites_usecase.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/shared/fourty_nine_shared_data.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/get_sub_categories_use_case.dart';

part 'main_categories_taps_state.dart';

class MainCategoriesTapsCubit extends Cubit<MainCategoriesTapsState> {
  final GetSubCategoriesUseCase _getSubCategoriesUseCase;
  final ToggleSubCategoryToFavoritesUseCase
      _toggleSubCategoryToFavoritesUseCase;
  MainCategoriesTapsCubit(
      this._getSubCategoriesUseCase, this._toggleSubCategoryToFavoritesUseCase)
      : super(MainCategoriesTapsState()) {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          !_isLastPage) {
        loadData();
      }
    });
  }

  final _mainCategories = FourtyNineSharedData.instance.mainCategories;
  List<SubCategoryEntity> _subCategories = [];

  void selectMainCategory(int index) {
    if (index != state.selectedIndex) {
      _subCategories = [];
      _paginationParams = PaginationParams.basic();
      emit(state.copyWith(selectedIndex: index, status: StateStatus.updated));
      loadData();
    }
  }

  final scrollController = ScrollController();
  PaginationParams _paginationParams = PaginationParams.basic();
  bool _isLastPage = false;

  Future<void> loadData() async {
    emit(state.copyWith(status: StateStatus.loading));
    final user = UserCubit.to.state.data?.id;
    final result = await _getSubCategoriesUseCase(GetSubCategoriesParams(
      mainCategoryId: selectedCategory.id,
      paginationParams: _paginationParams,
      userId: user ?? '',
    ));
    result.fold(
        (l) => emit(state.copyWith(status: StateStatus.error, failure: l)),
        (r) {
      _paginationParams.page++;
      _subCategories.addAll(r);
      _isLastPage = r.isEmpty || r.length < _paginationParams.limit;
      emit(state.copyWith(
          status: StateStatus.success, subCategories: _subCategories));
    });
  }

  List<MainCategoryEntity> get mainCategories => _mainCategories;
  MainCategoryEntity get selectedCategory =>
      _mainCategories[state.selectedIndex];

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
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
