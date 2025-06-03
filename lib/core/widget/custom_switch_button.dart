import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

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
        padding: EdgeInsets.zero,
        value: value,
        onChanged: onChanged,
        thumbColor:
            // thumbColor ?? WidgetStatePropertyAll(context.isDarkMode? Colors.white : AppColors.PRIMARY_COLOR),
            thumbColor ??
                WidgetStatePropertyAll(
                    context.isDarkMode ? Color(0xff0D0D0D) : Colors.white),
        // trackOutlineColor: value
        //     ? const WidgetStatePropertyAll(Colors.transparent)
        //     : trackOutlineColor ??
        //         WidgetStatePropertyAll(context.isDarkMode
        //             ? Colors.white
        //             : AppColors.PRIMARY_COLOR),
        // trackOutlineColor: WidgetStatePropertyAll(context.isDarkMode
        //     ? const Color(0xffF45560)
        //     : const Color(0xffF33D49)),
        trackOutlineWidth: const WidgetStatePropertyAll(1),
        // inactiveTrackColor: Theme.of(context).scaffoldBackgroundColor,
        inactiveTrackColor:
            context.isDarkMode ? Color(0xff333333) : const Color(0xffD9D9D9),
        // activeTrackColor: activeTrackColor ?? HexColor('4CDA64'),
        activeTrackColor: activeTrackColor ??
            (context.isDarkMode ? Colors.white : Colors.black),
      ),
    );
  }
}
