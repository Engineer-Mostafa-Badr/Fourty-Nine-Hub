import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/core/utils/hex_color_helper.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_entity.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_wallet_entity.dart';
import 'package:fourtyninehub/features/lucky_wheel/presentation/controllers/spin_wheel_cubit/spin_wheel_cubit.dart';
import 'package:fourtyninehub/features/lucky_wheel/presentation/controllers/wheel_cubit/wheel_cubit.dart';
import 'package:fourtyninehub/features/lucky_wheel/presentation/controllers/wheel_wallet_cubit/wheel_wallet_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../core/enums/wheel.dart';
import '../../../../core/widget/custom_scaffold.dart';
import '../../../../res/style/styles.dart';
import '../../domain/entities/wheel_item_entity.dart';

class LuckyWheelView extends StatelessWidget {
  const LuckyWheelView({super.key});

  @override
  Widget build(BuildContext context) {
    final spinWheelCubit = BlocProvider.of<SpinWheelCubit>(context);
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          centerTitle: false,
          label: LocaleKeys.luckyWheel.localize,
        ),
      ),
      body: BlocConsumer<WheelCubit, BasicState<WheelEntity>>(
        listener: (BuildContext context, BasicState<WheelEntity> state) {
          if (state.status == StateStatus.error) {
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
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(200),
                              ),
                              color: AppColors.PRIMARY_COLOR,
                            ),
                            height: 80,
                            child: Column(
                              crossAxisAlignment: context.isArabic
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleKeys.money.localize,
                                  style: Styles.mediumText(
                                    color: context.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: context.isArabic
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${state.data?.amount.round() ?? 0}',
                                      style: Styles.mediumText(
                                        color: context.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // const Sizer(),
                        const SizedBox(
                          width: 1,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsetsDirectional.symmetric(
                                vertical: 15.h, horizontal: 15.w),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(200),
                              ),
                              color: HexColor('F75699'),
                            ),
                            height: 80,
                            child: Column(
                              crossAxisAlignment: context.isArabic
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.end,
                              children: [
                                Text(
                                  LocaleKeys.points.localize,
                                  style: Styles.mediumText(
                                    color: context.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: context.isArabic
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${state.data?.points.round() ?? 0}',
                                      style: Styles.mediumText(
                                        color: context.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
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
                                    style: FortuneItemStyle(
                                        color: itemColor(context,
                                            state.data!.items.indexOf(e)),
                                        borderColor: Colors.transparent),
                                    child: Label(
                                      text: e.type == WheelItemTypes.point
                                          ? '${e.value.round()} ${LocaleKeys.points.localize}'
                                          : '${e.value.round()} ${LocaleKeys.money.localize}',
                                      style: Styles.headerText(
                                          color: context.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.normal),
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
                    radius: 30,
                    height: 80.h,
                    width: double.infinity,
                    label: LocaleKeys.spin.localize,
                    backColor: Theme.of(context).primaryColor,
                    style: Styles.mediumText(
                      fontSize: 60.sp,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    onPressed: () {
                      return spinWheelCubit.spin(state.data!, context);
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

  Color itemColor(BuildContext context, int index) {
    bool isDark = context.isDarkMode;

    List<Color> darkColors = [
      Colors.white.withValues(alpha: 0.1),
      Colors.white.withValues(alpha: 0.2),
      Colors.white.withValues(alpha: 0.3),
      Colors.white.withValues(alpha: 0.4),
      Colors.white.withValues(alpha: 0.45),
    ];

    List<Color> lightColors = [
      Colors.black.withValues(alpha: 0.1),
      Colors.black.withValues(alpha: 0.2),
      Colors.black.withValues(alpha: 0.3),
      Colors.black.withValues(alpha: 0.4),
      Colors.black.withValues(alpha: 0.45),
    ];

    List<Color> colors = isDark ? darkColors : lightColors;

    return colors[index % colors.length];
  }
}
