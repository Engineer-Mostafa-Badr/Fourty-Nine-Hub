import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/doctor_dashboard/doctor_dashboard_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class DoctorRenewDayCountWidget extends StatelessWidget {
  const DoctorRenewDayCountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: LocaleKeys.deadlineSubscription.localize,
          style: Styles.headerText(),
        ),
        const Sizer(),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: cardDarkColor(context),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ]),
          child: Row(
            children: [
              Expanded(
                child: BlocBuilder<DoctorDashboardCubit, DoctorDashboardState>(
                  builder: (context, state) {
                    String days = '0';
                    days =
                        state.info?.remainingDaysToEndSubscription.toString() ??
                            '';
                    return _Item(
                      numerOfDays: days,
                      label: LocaleKeys.subscription.localize,
                      onTap: () {
                        ManageVibration.vibrate();
                      },
                    );
                  },
                ),
              ),
              const Sizer(),
              Expanded(
                child: BlocBuilder<DoctorDashboardCubit, DoctorDashboardState>(
                  builder: (context, state) {
                    String days = '0';
                    days = state.info?.remainingDaysToExpiryId.toString() ?? '';
                    return _Item(
                      numerOfDays: days,
                      label: LocaleKeys.id.localize,
                      onTap: () {
                        ManageVibration.vibrate();
                      },
                      // onTap: () => context.pushNamed(Routes.EDITDOCTORDOCS),
                    );
                  },
                ),
              ),
              const Sizer(),
              Expanded(
                child: BlocBuilder<DoctorDashboardCubit, DoctorDashboardState>(
                  builder: (context, state) {
                    String days = '0';
                    days = state.info?.remainingDaysToExpiryPracticingId
                            .toString() ??
                        '';
                    return _Item(
                      numerOfDays: days,
                      label: LocaleKeys.practiceCertification.localize,
                      onTap: () {
                        ManageVibration.vibrate();
                      },
                      // onTap: () => context.pushNamed(Routes.EDITDOCTORDOCS),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  final String numerOfDays;
  final String label;
  final Function onTap;
  const _Item({
    required this.numerOfDays,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ManageVibration.vibrate();
        onTap();
      },
      child: Column(
        children: [
          Label(
            text: numerOfDays,
            style: Styles.headerText(color: AppColors.SECONDARY_COLOR),
          ),
          Label(
            text: label,
            style: Styles.mediumText(),
          ),
        ],
      ),
    );
  }
}
