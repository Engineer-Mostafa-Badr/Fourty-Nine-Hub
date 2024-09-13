import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DoctorDetailsInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const DoctorDetailsInfoCard(
      {super.key, required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: color ?? AppColors.PRIMARY_COLOR,
          size: 24,
        ),
        Sizer(),
        Expanded(child: Label(text: label, style: Styles.mediumText())),
      ],
    );
  }
}
