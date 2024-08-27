import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../dynamic/sizer.dart';
import '../labels/label.dart';

class AppButton extends StatelessWidget {
  final double? height, margin, padding, radius, width, iconSize;
  final Color? backColor, textColor;
  final String label;
  final Function onPressed;
  final Widget? widget;
  final TextStyle? style;
  final IconData? icon;
  final Color? color;

  const AppButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.backColor,
      this.height,
      this.radius,
      this.margin,
      this.widget,
      this.padding,
      this.iconSize,
      this.textColor,
      this.style,
      this.icon,
      this.color,
      this.width});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(),
      child: Container(
        height: height ?? kToolbarHeight * .6,
        width: width,
        margin: EdgeInsets.all(margin ?? 0),
        padding: EdgeInsets.symmetric(horizontal: padding ?? 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 10.zR),
          color: backColor ?? AppColors.SECONDARY_COLOR,
        ),
        child: widget ??
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null)
                    Icon(
                      icon,
                      size: iconSize ?? 16,
                      color: textColor ?? Colors.white,
                    ),
                  if (icon != null)
                    const Sizer(
                      width: 3,
                    ),
                  Label(
                      text: label,
                      style: style ?? Styles.mediumText(color: color)),
                ],
              ),
            ),
      ),
    );
  }
}
