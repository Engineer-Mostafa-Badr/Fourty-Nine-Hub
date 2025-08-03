import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../domain/entities/slider_item_entity.dart';
import '../../../domain/use_cases/get_slider_items_usecase.dart';

import '../../../../../core/enums/base_status_enum.dart';
import '../../../../../core/states/basic_state.dart';

class SliderCubit extends Cubit<BasicState<List<SliderItemEntity>>> {
  final GetSliderItemsUseCase _getSliderItemsUseCase;

  SliderCubit(this._getSliderItemsUseCase)
      : super(
          const BasicState(),
        );

  void loadData() async {
    print("objectLSADSALD:AS");
    emit(state.copyWith(status: StateStatus.loading));
    final result = await _getSliderItemsUseCase.call(const NoParams());
    print("objectLSADSALD:AS");

    emit(
      result.fold(
        (failure) {
          print("objectLSADSALD:AS");
          print('there is an error ${failure.toString()}');
          return state.copyWith(
            failure: failure,
            status: StateStatus.error,
          );
        },
        (data) {
          print("objectLSADSALD:AS");
          print('data is $data');
          return state.copyWith(
            status: StateStatus.success,
            data: data,
          );
        },
      ),
    );
  }
}
