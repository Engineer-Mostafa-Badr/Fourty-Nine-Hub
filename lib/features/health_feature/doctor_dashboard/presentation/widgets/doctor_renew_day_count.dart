import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/doctor_dashboard/doctor_dashboard_cubit.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorRenewDayCountWidget extends StatelessWidget {
  const DoctorRenewDayCountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: Labels.deadline,
          style: Styles.headerText(),
        ),
        const Sizer(),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).primaryColor,
          ),
          child: Row(
            children: [
              Expanded(
                child: BlocBuilder<DoctorDashboardCubit, DoctorDashboardState>(
                  buildWhen: (previous, current) =>
                      current is DoctorDashboardInitial ||
                      current is DoctorInfoSuccessState,
                  builder: (context, state) {
                    String days = '0';
                    if (state is DoctorInfoSuccessState) {
                      days = state.info.remainingDaysToEndSubscription.toString();
                    }
                    return _Item(
                      numerOfDays: days,
                      label: Labels.subscription,
                      onTap: () {},
                    );
                  },
                ),
              ),
              const Sizer(),
              Expanded(
                child: BlocBuilder<DoctorDashboardCubit, DoctorDashboardState>(
                  buildWhen: (previous, current) =>
                      current is DoctorDashboardInitial ||
                      current is DoctorInfoSuccessState,
                  builder: (context, state) {
                    String days = '0';
                    if (state is DoctorInfoSuccessState) {
                      days = state.info.remainingDaysToExpiryId.toString();
                    }
                    return _Item(
                      numerOfDays: days,
                      label: Labels.id, onTap: () {},
                      // onTap: () => context.push(Routes.EDITDOCTORDOCS),
                    );
                  },
                ),
              ),
              const Sizer(),
              Expanded(
                child: BlocBuilder<DoctorDashboardCubit, DoctorDashboardState>(
                  buildWhen: (previous, current) =>
                      current is DoctorDashboardInitial ||
                      current is DoctorInfoSuccessState,
                  builder: (context, state) {
                    String days = '0';
                    if (state is DoctorInfoSuccessState) {
                      days = state.info.remainingDaysToExpiryPracticingId.toString();
                    }
                    return _Item(
                      numerOfDays: days,
                      label: Labels.practiceCertification, onTap: () {},
                      // onTap: () => context.push(Routes.EDITDOCTORDOCS),
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
            style: Styles.mediumText(
                color: Theme.of(context).scaffoldBackgroundColor),
          ),
        ],
      ),
    );
  }
}
