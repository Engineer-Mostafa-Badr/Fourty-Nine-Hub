import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/utils/hex_color_helper.dart';

import '../../res/style/app_colors.dart';

class CustomSwitchButton extends StatelessWidget {
  const CustomSwitchButton({
    super.key,
    required this.value,
    required this.onChanged,
    this.trackColor,
    this.trackOutlineColor,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.thumbColor,
  });

  final bool value;
  final void Function(bool)? onChanged;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final WidgetStateProperty<Color?>? trackColor;
  final WidgetStateProperty<Color?>? trackOutlineColor;
  final WidgetStateProperty<Color?>? thumbColor;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: .7,
      child: Switch(
        value: value,
        onChanged: onChanged,
        thumbColor:
            thumbColor ?? WidgetStatePropertyAll(context.isDarkMode? Colors.white : AppColors.PRIMARY_COLOR),
        trackOutlineColor: value
            ? const WidgetStatePropertyAll(Colors.transparent)
            : trackOutlineColor ??
            WidgetStatePropertyAll(context.isDarkMode? Colors.white : AppColors.PRIMARY_COLOR),
        inactiveTrackColor: Theme.of(context).scaffoldBackgroundColor,
        activeTrackColor: activeTrackColor ?? HexColor('4CDA64'),
      ),
    );
  }
}
