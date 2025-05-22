import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_entity.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_item_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../common/widgets/stateless/buttons/elevated_button.dart';
import '../../../../../core/enums/wheel.dart';
import '../../../../../core/utils/custom_show_dialog.dart';
import '../../../domain/use_cases/spin_wheel_use_case.dart';

class SpinWheelCubit extends Cubit<BasicState<WheelItemEntity>> {
  final SpinWheelUseCase _spinWheelUseCase;
  final controller = StreamController<int>();

  SpinWheelCubit(
    this._spinWheelUseCase,
  ) : super(const BasicState());

  bool isMessageShown = false;

  Future<void> spin(WheelEntity wheel,BuildContext context) async {
    if (state.status == StateStatus.loading) return;
    emit(state.copyWith(status: StateStatus.loading));
    final result = await _spinWheelUseCase(wheel.id);
    emit(
      result.fold(
        (failure) {
          showErrorMessage(context, getFailureMessage(failure,context));
          return state.copyWith(
          status: StateStatus.error,
          failure: failure,
        );
        },
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
    showAnimatedDialog(context,Center(
      child: AlertDialog(
        scrollable: false,
        backgroundColor: AppColors.getFindFillColor(context),
        title: Center(child: Text(LocaleKeys.youWin.localize)),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                prize.type == WheelItemTypes.point
                    ? '${FormatNumbers().formatNumber(prize.value.round(), useArabicNumerals: context.isArabic)} ${LocaleKeys.points.localize}'
                    : '${FormatNumbers().formatNumber(prize.value.round(), useArabicNumerals: context.isArabic)} ${LocaleKeys.cash.localize}',
                style: TextStyle(fontSize: 30.sp),
              ),
              const Sizer(),
              ElevatedAppButton(
                label: context.isArabic?'رجوع':LocaleKeys.back.localize,
                textStyle: Styles.mediumText(
                    color: AppColors.getReversedTextColor(context)),
                backColor: AppColors.getRedColor(context),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    ),barrierDismissible: true,);
    // showDialog(
    //   barrierDismissible: true,
    //   context: context,
    //   builder: (BuildContext context) {
    //     return Center(
    //       child: AlertDialog(
    //         scrollable: false,
    //         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    //         title: Center(child: Text(LocaleKeys.youWin.localize)),
    //         content: SingleChildScrollView(
    //           child: Column(
    //             children: [
    //               Text(
    //                 prize.type == WheelItemTypes.point
    //                     ? '${prize.value} ${LocaleKeys.points.localize}'
    //                     : '${prize.value}',
    //                 style: TextStyle(fontSize: 30.sp),
    //               ),
    //               ElevatedAppButton(
    //                 label: LocaleKeys.back.localize,
    //                 textStyle: Styles.mediumText(
    //                     color: AppColors.AUTH_CONTAINER_COLOR),
    //                 backColor: AppColors.SECONDARY_COLOR,
    //                 onPressed: () {
    //                   Navigator.pop(context);
    //                 },
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );
  }

  @override
  Future<void> close() {
    controller.close();
    return super.close();
  }
}
