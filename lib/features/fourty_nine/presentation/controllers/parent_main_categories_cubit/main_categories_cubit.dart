import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_categories_use_case.dart';

class MainCategoriesCubit extends Cubit<BasicState<List<MainCategoryEntity>>> {
  final GetMainCategoriesUseCase _getMainCategoriesUseCase;

  MainCategoriesCubit(
    this._getMainCategoriesUseCase,
  ) : super(const BasicState());

  Future<List<MainCategoryEntity>> getMainCategories(
      PaginationParams params) async {
    List<MainCategoryEntity> data = [];
    emit(state.copyWith(status: StateStatus.loading));
    final result = await _getMainCategoriesUseCase.call(params);

    result.fold(
      (failure) => state.copyWith(
        failure: failure,
        status: StateStatus.error,
      ),
      (r) => data = r,
    );
    return data;
  }
}
