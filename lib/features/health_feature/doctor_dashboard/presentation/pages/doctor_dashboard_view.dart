import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/doctor_subscription_details.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/doctor_today_appointments.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/doctor_unhandled_appointments.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class DoctorDashboardView extends StatelessWidget {
  const DoctorDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      appBar: AppBar(
        title: const Text(Labels.doctorDashboard),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: 2,
                child: Text(Labels.editProfile),
              ),
              const PopupMenuItem(
                value: 3,
                child: Text(Labels.history),
              ),
            ];
          })
        ],
      ),
      body: ListView(
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
    );
  }
}
