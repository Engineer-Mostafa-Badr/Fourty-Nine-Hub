import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
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
    return BlocListener<DoctorDashboardCubit, DoctorDashboardState>(
      listener: (context, state) {
        switch (state) {
          case DoctorDashboardShowSuccessfulMessage _:
            showSuccessMessage(context, state.message);
            break;
          case DoctorDashboardError _:
            showErrorMessage(context, state.message);
            break;

          case DoctorDashboardStartLoading _:
            showLoadingDialog(context);
            break;

          case DoctorDashboardStopLoading _:
            context.pop();
            break;
          default:
            break;
        }
      },
      child: Scaffold(
        appBar: const BackAppBar(
          label: Labels.doctorDashboard,
          actions: [
            DoctorDashboardPopupMenuButton(),
          ],
        ),
        body: ListView(
          padding:  EdgeInsets.all(18),
          children: [
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
