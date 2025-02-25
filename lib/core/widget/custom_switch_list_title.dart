import 'package:flutter/material.dart';

import '../../res/style/app_colors.dart';
import '../utils/hex_color_helper.dart';

class CustomSwitchListTile extends StatelessWidget {
  const CustomSwitchListTile({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.inactiveThumbColor,
    this.trackColor,
    this.trackOutlineColor,
    this.secondary,
    this.title,
    this.subtitle,
  });

  final bool value;
  final void Function(bool)? onChanged;
  final Widget? secondary;
  final Widget? title;
  final Widget? subtitle;
  final Color? activeColor;
  final Color? inactiveThumbColor;
  final WidgetStateProperty<Color?>? trackColor;
  final WidgetStateProperty<Color?>? trackOutlineColor;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      secondary: secondary,
      title: title,
      subtitle: subtitle,
      value: value,
      onChanged: onChanged,
      thumbColor: const WidgetStatePropertyAll(AppColors.PRIMARY_COLOR),
      trackOutlineColor: value
          ? const WidgetStatePropertyAll(Colors.transparent)
          : const WidgetStatePropertyAll(AppColors.PRIMARY_COLOR),

      inactiveTrackColor: Theme.of(context).scaffoldBackgroundColor,
      activeTrackColor: HexColor('4CDA64'),
      // activeColor: activeColor ?? Colors.green,
      // inactiveThumbColor: inactiveThumbColor ?? AppColors.PRIMARY_COLOR,
      // trackColor: trackColor ??
      //     WidgetStatePropertyAll(Theme.of(context).scaffoldBackgroundColor),
      // trackOutlineColor: trackOutlineColor ??
      //     const WidgetStatePropertyAll(AppColors.PRIMARY_COLOR),
      // inactiveTrackColor: Colors.black,
      // activeTrackColor: Colors.black,
      // trackOutlineColor: WidgetStatePropertyAll(HexColor('ff3308')),
    );
  }
}
