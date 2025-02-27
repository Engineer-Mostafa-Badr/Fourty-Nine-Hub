import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/utils/hex_color_helper.dart';

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
      // activeColor: activeColor ?? Colors.green,
      // inactiveThumbColor: inactiveThumbColor ?? AppColors.PRIMARY_COLOR,
      // trackColor: trackColor ??
      //     WidgetStatePropertyAll(Theme.of(context).scaffoldBackgroundColor),
      thumbColor: const WidgetStatePropertyAll(AppColors.PRIMARY_COLOR),
      trackOutlineColor: value
          ? const WidgetStatePropertyAll(Colors.transparent)
          : const WidgetStatePropertyAll(AppColors.PRIMARY_COLOR),

      inactiveTrackColor: Theme.of(context).scaffoldBackgroundColor,
      activeTrackColor: HexColor('4CDA64'),
      // trackOutlineColor: WidgetStatePropertyAll(HexColor('ff3308')),
    );
  }
}
