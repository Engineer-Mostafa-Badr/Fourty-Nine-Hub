import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ValidationErrorWidget extends StatelessWidget {
  const ValidationErrorWidget({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Sizer(
          height: 10,
        ),
        Text(
          message,
          style: Styles.mediumText(
              color: AppColors.SECONDARY_COLOR_DARK, fontSize: 27),
        )
      ],
    );
  }
}
