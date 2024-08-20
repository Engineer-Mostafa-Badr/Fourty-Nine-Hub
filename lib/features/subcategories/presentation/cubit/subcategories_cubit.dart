import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../domain/usecases/get_sub_categories_use_case.dart';
import '../../domain/entities/sub_category_entity.dart';

part 'subcategories_state.dart';

class SubcategoriesCubit extends Cubit<SubcategoriesState> {
  final GetSubCategoriesUseCase _getSubcategoriesUsecase;
  SubcategoriesCubit(this._getSubcategoriesUsecase)
      : super(const SubcategoriesState());

  String _mainCategoryId = '';

  init({required String mainCategoryId}) {
    _mainCategoryId = mainCategoryId;
  }

  Future<List<SubCategoryEntity>> getSubcategories(
      {required PaginationParams paginationParams}) async {
    List<SubCategoryEntity> data = [];
    emit(state.copyWith(status: SubcategoriesStates.loading));
    final response = await _getSubcategoriesUsecase(GetSubCategoriesParams(
        mainCategoryId: _mainCategoryId, paginationParams: paginationParams));
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: SubcategoriesStates.error)),
        (r) => data = r);

    return data;
  }
}
