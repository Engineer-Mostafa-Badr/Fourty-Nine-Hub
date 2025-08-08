import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';

import '../../../../../../helpers/manage_vibration.dart';
import '../../../../../../helpers/manage_vibration.dart';

class AvaialbleTripsButton extends StatelessWidget {
  const AvaialbleTripsButton({
    super.key,
    required this.title,
    this.onTap,
    this.color,
    this.noFill = false,
    this.icon,
    this.padding,
    this.radius = 5,
  });
  final void Function()? onTap;
  final Color? color;
  final String title;
  final bool noFill;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ManageVibration.vibrate();
        onTap?.call();
      },
      child: Container(
        padding: padding ?? EdgeInsets.symmetric(vertical: 5.h),
        decoration: BoxDecoration(
          color: noFill ? null : color,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: color ?? Colors.transparent),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon != null
                ? Icon(icon, color: AppColors.getReversedTextColor(context), size: 20)
                : const SizedBox(),
            const Sizer(width: 5),
            Text(
              title,
              style: Styles.headerText(color: AppColors.getReversedTextColor(context), fontSize: 30),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}