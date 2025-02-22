import 'package:flutter/material.dart';

import '../../res/style/app_colors.dart';

class CustomSwitchButton extends StatelessWidget {
  const CustomSwitchButton({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.inactiveThumbColor,
    this.trackColor,
    this.trackOutlineColor,
  });

  final bool value;
  final void Function(bool)? onChanged;
  final Color? activeColor;
  final Color? inactiveThumbColor;
  final WidgetStateProperty<Color?>? trackColor;
  final WidgetStateProperty<Color?>? trackOutlineColor;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor ?? Colors.green,
      inactiveThumbColor: inactiveThumbColor ?? AppColors.PRIMARY_COLOR,
      trackColor: trackColor ??
          WidgetStatePropertyAll(Theme.of(context).scaffoldBackgroundColor),
      trackOutlineColor: trackOutlineColor ??
          const WidgetStatePropertyAll(AppColors.PRIMARY_COLOR),
      // inactiveTrackColor: Colors.black,
      // activeTrackColor: Colors.black,
      // trackOutlineColor: WidgetStatePropertyAll(HexColor('ff3308')),
    );
  }
}
