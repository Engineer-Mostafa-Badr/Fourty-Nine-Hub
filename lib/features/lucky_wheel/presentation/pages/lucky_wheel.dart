import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_entity.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_wallet_entity.dart';
import 'package:fourtyninehub/features/lucky_wheel/presentation/controllers/spin_wheel_cubit/spin_wheel_cubit.dart';
import 'package:fourtyninehub/features/lucky_wheel/presentation/controllers/wheel_cubit/wheel_cubit.dart';
import 'package:fourtyninehub/features/lucky_wheel/presentation/controllers/wheel_wallet_cubit/wheel_wallet_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import '../../../../core/enums/wheel.dart';
import '../../../../res/style/styles.dart';
import '../../domain/entities/wheel_item_entity.dart';

class LuckyWheelView extends StatelessWidget {
  const LuckyWheelView({super.key});

  @override
  Widget build(BuildContext context) {
    final spinWheelCubit = BlocProvider.of<SpinWheelCubit>(context);
    return Scaffold(
      appBar: BackAppBar(
        centerTitle: false,
        label: LocaleKeys.luckyWheel.localize,
      ),
      body: BlocConsumer<WheelCubit, BasicState<WheelEntity>>(
        listener: (BuildContext context, BasicState<WheelEntity> state) {
          if (state.failure == null) {
            showSuccessMessage(
              context,
              color: AppColors.SECONDARY_COLOR,
              LocaleKeys.playedSpins.localize,
            );
          }
        },
        builder: (context, state) {
          if (state.status != StateStatus.success) {
            return const Center(child: CircularProgressIndicator());
          }
          return BlocBuilder<SpinWheelCubit, BasicState<WheelItemEntity>>(
            builder: (_, priceState) => Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  BlocBuilder<WheelWalletCubit, BasicState<WheelWalletEntity>>(
                    builder: (_, state) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsetsDirectional.symmetric(
                                vertical: 15.h, horizontal: 15.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: Theme.of(context).primaryColor),
                            child: Row(
                              children: [
                                Text(
                                  LocaleKeys.money.localize,
                                  style: Styles.mediumText(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                                ),
                                const Spacer(),
                                Text(
                                  '${state.data?.amount.round() ?? 0}',
                                  style: Styles.mediumText(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Sizer(),
                        Expanded(
                          child: Container(
                            padding: EdgeInsetsDirectional.symmetric(
                                vertical: 15.h, horizontal: 15.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: Theme.of(context).primaryColor),
                            child: Row(
                              children: [
                                Text(
                                  LocaleKeys.points.localize,
                                  style: Styles.mediumText(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                                ),
                                const Spacer(),
                                Text(
                                  '${state.data?.points.round() ?? 0}',
                                  style: Styles.mediumText(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: state.data != null && state.data!.items.length > 1
                        ? FortuneWheel(
                            selected: spinWheelCubit.controller.stream,
                            animateFirst: false,
                            duration: const Duration(seconds: 3),
                            hapticImpact: HapticImpact.heavy,
                            onAnimationEnd: () {
                              spinWheelCubit.showPrize(context);
                              context.read<WheelWalletCubit>().getWheelWallet();
                            },
                            items: state.data!.items
                                .map(
                                  (e) => FortuneItem(
                                    child: Text(
                                      e.type == WheelItemTypes.point
                                          ? '${e.value.round()} ${LocaleKeys.points.localize}'
                                          : '${e.value.round()} ${LocaleKeys.money.localize}',
                                      style: Styles.mediumText(
                                        fontSize: 40.sp,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          )
                        : Center(
                            child: Text(LocaleKeys.notEnoughWheel.localize),
                          ),
                  ),
                  AppButton(
                    height: 80.h,
                    width: double.infinity,
                    label: LocaleKeys.spin.localize,
                    backColor: Theme.of(context).primaryColor,
                    style: Styles.headerText(
                      fontSize: 70.sp,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    onPressed: () {
                      return spinWheelCubit.spin(state.data!);
                    },
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
