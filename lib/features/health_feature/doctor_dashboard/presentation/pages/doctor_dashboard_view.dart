import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/doctor_dashboard/doctor_dashboard_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/doctor_renew_day_count.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/doctor_today_appointments.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/doctor_unhandled_appointments.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/popup_menu.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:go_router/go_router.dart';

class DoctorDashboardView extends StatelessWidget {
  const DoctorDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorDashboardCubit, DoctorDashboardState>(
      listener: (context, state) {
        // switch (state) {
        //   case DoctorDashboardShowSuccessfulMessage _:
        //     showSuccessMessage(context, state.message);
        //     break;
        //   case DoctorDashboardError _:
        //     showErrorMessage(context, state.message);
        //     break;
        //
        //   case DoctorDashboardStartLoading _:
        //     showLoadingDialog(context);
        //     break;
        //
        //   case DoctorDashboardStopLoading _:
        //     context.pop();
        //     break;
        //   default:
        //     break;
        // }
      },
      builder: (context, state) =>  Scaffold(
        appBar: BackAppBar(
          label: LocaleKeys.doctorDashboard.localize,
          actions: [
            DoctorDashboardPopupMenuButton(earnedMoney: context.read<DoctorDashboardCubit>().totalEarnedMoney, subCategoryId: state.info?.subCategoryId??'',),
          ],
        ),
        body:state.status==DoctorDashboardStateStatus.startLoading?const Center(child: CircularProgressIndicator()): ListView(
          padding: const EdgeInsets.all(18),
          children: const [
            DoctorRenewDayCountWidget(),
            Sizer(),
            DoctorTodayAppointmentsWidget(),
            Sizer(),
            DoctorUnhandledAppointmentsWidget(),
            Sizer()
          ],
        ),
      ),
    );
  }
}
