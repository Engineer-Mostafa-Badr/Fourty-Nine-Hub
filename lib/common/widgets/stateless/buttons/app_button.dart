import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  final MainAxisAlignment? mainAxisAlignment;
  const AppButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.backColor,
      this.height,
      this.radius,
      this.margin,
      this.mainAxisAlignment,
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
        height: height ?? kToolbarHeight * 1.2.h,
        width: width,
        margin: EdgeInsets.all(margin ?? 0),
        padding: EdgeInsets.symmetric(horizontal: padding ?? 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 10.r),
          color: backColor ?? AppColors.SECONDARY_COLOR,
        ),
        child: widget ??
            Center(
              child: Row(
                mainAxisAlignment:
                    mainAxisAlignment ?? MainAxisAlignment.center,
                children: [
                  if (icon != null)
                    Icon(
                      icon,
                      size: (iconSize ?? 30).sp,
                      color: textColor ?? Colors.white,
                    ),
                  if (icon != null)
                    Sizer(
                      width: 10.w,
                    ),
                  SizedBox(
                    child: Label(
                      text: label,
                      style: style ?? Styles.mediumText(color: color),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
