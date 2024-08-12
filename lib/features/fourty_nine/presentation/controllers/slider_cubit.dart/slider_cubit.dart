import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/slider_item_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_slider_items_usecase.dart';

import '../../../../../core/enums/base_status_enum.dart';
import '../../../../../core/states/basic_state.dart';

class SliderCubit extends Cubit<BasicState<List<SliderItemEntity>>> {
  final GetSliderItemsUseCase _getSliderItemsUseCase;

  SliderCubit(this._getSliderItemsUseCase)
      : super(
          const BasicState(),
        );

  void loadData() async {
    emit(state.copyWith(status: StateStatus.loading));
    final result = await _getSliderItemsUseCase.call(const NoParams());
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
