import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/usecases/request/get_ride_sub_categories_use_case.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/enums/base_status_enum.dart';
import '../../../../../core/states/basic_state.dart';

class RegistableSubCategoriesCubit
    extends Cubit<BasicState<List<SubCategoryEntity>>> {
  final GetSubCategoriesUseCase _getSubCategoriesUseCase;

  RegistableSubCategoriesCubit(this._getSubCategoriesUseCase)
      : super(
          const BasicState(),
        );

  void loadData() async {
    emit(state.copyWith(status: StateStatus.loading));
    final result = await _getSubCategoriesUseCase.call('');
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
