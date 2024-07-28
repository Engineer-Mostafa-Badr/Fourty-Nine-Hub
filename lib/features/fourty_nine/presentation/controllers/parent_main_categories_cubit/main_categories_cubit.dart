import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_categories_use_case.dart';

class MainCategoriesCubit extends Cubit<BasicState<List<MainCategoryEntity>>> {
  final GetMainCategoriesUseCase _getMainCategoriesUseCase;
  int page = 1;
  MainCategoriesCubit(this._getMainCategoriesUseCase)
      : super(
          const BasicState(),
        );

  Future<void> getMainCategories() async {
    emit(state.copyWith(status: StateStatus.loading));
    final result = await _getMainCategoriesUseCase
        .call(PaginationParams(limit: 3, page: 1));
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

  Future<void> getMainCategoriesPagination() async {
    emit(state.copyWith(status: StateStatus.loading));
    page++;
    final result = await _getMainCategoriesUseCase
        .call(PaginationParams(limit: 3, page: page));

    emit(
      result.fold(
          (failure) => state.copyWith(
                failure: failure,
                status: StateStatus.error,
              ), (data) {
        final list = state.data;
        for (var item in data) {
          final check = list?.contains(item) ?? false;
          if (!check) {
            (list ?? []).add(item);
          }
        }
        print(list);
        return state.copyWith(
          status: StateStatus.success,
          data: list,
        );
      }),
    );
  }
}
