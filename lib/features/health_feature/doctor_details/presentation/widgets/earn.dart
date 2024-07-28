import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/info.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class DoctoDetailsEarnCard extends StatelessWidget {
  const DoctoDetailsEarnCard({super.key});

  @override
  Widget build(BuildContext context) {
  
    return const DoctorDetailsInfoCard(
      icon: Icons.monetization_on_outlined,
      color: AppColors.ACCENT_COLOR,
      label: Labels.youWillEarn,
    );
  }
}