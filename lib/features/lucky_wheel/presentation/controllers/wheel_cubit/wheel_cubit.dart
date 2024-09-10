import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_entity.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/use_cases/get_wheel_use_case.dart';

class WheelCubit extends Cubit<BasicState<WheelEntity>> {
  final GetWheelUseCase _getWheelUseCase;

  WheelCubit(this._getWheelUseCase) : super(const BasicState());

  void getWheel() async {
    emit(state.copyWith(status: StateStatus.loading));
    final result = await _getWheelUseCase(const NoParams());
    emit(
      result.fold(
        (failure) {
          print(failure);
          return state.copyWith(status: StateStatus.error, failure: failure);
        },
        (wheel) => state.copyWith(status: StateStatus.success, data: wheel),
      ),
    );
  }
}
