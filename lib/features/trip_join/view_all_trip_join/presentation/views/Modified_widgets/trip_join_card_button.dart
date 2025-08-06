import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TripJoinCardButton extends StatelessWidget {
  const TripJoinCardButton({
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
      onTap: onTap,
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
                ? Icon(icon, color: Colors.white, size: 20)
                : const SizedBox(),
            const Sizer(width: 5),
            Expanded(
              child: Text(
                title,
                style: Styles.headerText(color: context.isDarkMode?Colors.black:Colors.white, fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
