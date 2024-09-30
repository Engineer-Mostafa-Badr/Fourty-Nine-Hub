import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_entity.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_item_entity.dart';

import '../../../../../common/widgets/stateless/buttons/elevated_button.dart';
import '../../../../../core/enums/wheel.dart';
import '../../../domain/use_cases/spin_wheel_use_case.dart';

class SpinWheelCubit extends Cubit<BasicState<WheelItemEntity>> {
  final SpinWheelUseCase _spinWheelUseCase;
  final controller = StreamController<int>();

  SpinWheelCubit(
    this._spinWheelUseCase,
  ) : super(const BasicState());

  bool isMessageShown = false;

  Future<void> spin(WheelEntity wheel) async {
    if (state.status == StateStatus.loading) return;
    emit(state.copyWith(status: StateStatus.loading));
    final result = await _spinWheelUseCase(wheel.id);
    emit(
      result.fold(
        (failure) => state.copyWith(
          status: StateStatus.error,
          failure: failure,
        ),
        (item) {
          isMessageShown = false;
          final prizeIndex = wheel.items.indexWhere((e) =>
              e.value == item.value &&
              e.type == item.type &&
              e.name == item.name);
          if (prizeIndex != -1) {
            controller.add(prizeIndex);
          }
          return state.copyWith(
            status: StateStatus.success,
            data: item,
          );
        },
      ),
    );
  }

  void showPrize(BuildContext context) {
    if (state.data == null || isMessageShown) return;
    isMessageShown = true;
    final prize = state.data!;
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            scrollable: false,
            title: const Center(child: Text("You Win!")),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    prize.type == WheelItemTypes.point
                        ? '${prize.value} Points'
                        : '${prize.value}',
                    style: TextStyle(fontSize: 30.sp),
                  ),
                  ElevatedAppButton(
                    label: 'back',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    controller.close();
    return super.close();
  }
}
