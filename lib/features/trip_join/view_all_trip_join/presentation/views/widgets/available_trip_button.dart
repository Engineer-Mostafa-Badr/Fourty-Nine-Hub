import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class AvaialbleTripsButton extends StatelessWidget {
  const AvaialbleTripsButton({
    super.key,
    required this.title,
    this.onTap,
    this.color,
    this.noFill = false,
    this.icon,
    this.padding,
  });
  final void Function()? onTap;
  final Color? color;
  final String title;
  final bool noFill;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? EdgeInsets.symmetric(vertical: 5.h),
        decoration: BoxDecoration(
          color: noFill ? null : color,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: color ?? Colors.transparent),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon != null
                ? Icon(icon, color: Colors.white, size: 20)
                : const SizedBox(),
            const Sizer(width: 5),
            Text(
              title,
              style: Styles.headerText(color: Colors.white, fontSize: 30),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
