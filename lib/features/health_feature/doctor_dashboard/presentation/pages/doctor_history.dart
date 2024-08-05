import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/history/doctor_history_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class DoctorHistoryView extends StatelessWidget {
  const DoctorHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          DoctorHistoryCard(
            title: 'Total Appointments',
            totalValue: 560,
            clinicValue: 20,
            callValue: 250,
            homeVisitValue: 290,
          ),
          Sizer(
            height: 20,
          ),
          DoctorHistoryCard(
            title: 'Total Earned',
            totalValue: 680458,
            clinicValue: 226819,
            callValue: 231542,
            homeVisitValue: 222097,
          ),
        ],
      ),
    );
  }
}
