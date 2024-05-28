import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/parent_main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_parent_main_categories_use_case.dart';

class ParentMainCategoriesCubit
    extends Cubit<BasicState<List<ParentMainCategoryEntity>>> {
  final GetParentMainCategoriesUseCase _getParentMainCategoriesUseCase;

  ParentMainCategoriesCubit(this._getParentMainCategoriesUseCase)
      : super(
          const BasicState(),
        );

  Future<void> getParentMainCategories() async {
    emit(state.copyWith(status: StateStatus.loading));
    final result = await _getParentMainCategoriesUseCase.call(const NoParams());
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
}
