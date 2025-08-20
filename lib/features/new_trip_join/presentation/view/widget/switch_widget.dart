import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/hex_color_helper.dart';
import '../../../../../res/style/app_colors.dart';

class SwitchWidget extends StatelessWidget {
  const SwitchWidget({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.inactiveThumbColor,
    this.trackColor,
    this.trackOutlineColor,
  });

  final String title;
  final bool value;
  final Function(bool p1) onChanged;
  final Color? activeColor;
  final Color? inactiveThumbColor;
  final WidgetStateProperty<Color?>? trackColor;
  final WidgetStateProperty<Color?>? trackOutlineColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.7, // increase or decrease
            child: SizedBox(
              height: 30,
              child: Switch(
                value: value,
                onChanged: onChanged,
                padding: EdgeInsets.zero,
                thumbColor: WidgetStatePropertyAll(
                  AppColors.getButtonPrimaryColor(context),
                ),
                trackOutlineColor: value
                    ? const WidgetStatePropertyAll(Colors.transparent)
                    : WidgetStatePropertyAll(
                  AppColors.getButtonPrimaryColor(context),
                ),
                inactiveTrackColor: Theme.of(context).scaffoldBackgroundColor,
                activeTrackColor: HexColor('4CDA64'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
