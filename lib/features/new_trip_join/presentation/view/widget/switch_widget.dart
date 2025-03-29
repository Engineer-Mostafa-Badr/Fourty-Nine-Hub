import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../res/style/app_colors.dart';

class SwitchWidget extends StatelessWidget {
  const SwitchWidget({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final Function(bool p1) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Switch(
            inactiveThumbColor: AppColors.PRIMARY_COLOR,
            inactiveTrackColor: Colors.white,
            value: value,
            onChanged: onChanged,
            hoverColor: AppColors.PRIMARY_COLOR,
            activeColor: AppColors.WHATS_APP_COLOR,
            activeTrackColor: AppColors.WHATS_APP_COLOR,
            thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.PRIMARY_COLOR;
              }
              return Colors.black;
            }),
          ),
        ],
      ),
    );
  }
}
