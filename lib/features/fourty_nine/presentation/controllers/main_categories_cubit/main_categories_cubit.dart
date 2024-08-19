import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_categories_use_case.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/shared/fourty_nine_shared_data.dart';

class MainCategoriesCubit extends Cubit<BasicState<List<MainCategoryEntity>>> {
  final GetMainCategoriesUseCase _getMainCategoriesUseCase;
  final FourtyNineSharedData _fourtyNineSharedData =
      FourtyNineSharedData.instance;

  MainCategoriesCubit(
    this._getMainCategoriesUseCase,
  ) : super(const BasicState());


  Future<void> loadData() async {
    if (_fourtyNineSharedData.mainCategories.isEmpty) {
     emit(state.copyWith(status: StateStatus.loading));
      final result = await _getMainCategoriesUseCase(
          PaginationParams(page: 1, limit: 100));

      result.fold(

        (failure) => state.copyWith(
          failure: failure,
          status: StateStatus.error,
        ),
        (r) {
         // _fourtyNineSharedData.mainCategories = r;
          emit(state.copyWith(status: StateStatus.loading));
          emit(state.copyWith(
              status: StateStatus.success,
              data: r));
        },
      );
    } else {
      emit(state.copyWith(status: StateStatus.loading));
      emit(state.copyWith(
          status: StateStatus.success,
          data: _fourtyNineSharedData.mainCategories));
    }
  }


}
