// Utility function to show snack bar after build
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showSnackBarAfterBuild({
  required BuildContext context,
  required String message,
  String? actionLabel,
  VoidCallback? onActionPressed,
  IconData? icon,
  Color backgroundColor = Colors.black,
  Color textColor = Colors.red,
  Color actionTextColor = Colors.blue,
  Duration duration = const Duration(seconds: 1),
}) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: textColor,
              fontSize: 30.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (icon != null)
          Icon(
            icon,
            color: Colors.green,
            size: 50.h,
          ),
      ],
    ),
    backgroundColor: backgroundColor,
    duration: duration,
    action: actionLabel != null
        ? SnackBarAction(
            label: actionLabel,
            onPressed: onActionPressed ?? () {},
            textColor: actionTextColor,
          )
        : null,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    margin: const EdgeInsets.all(16),
    elevation: 10,
  );
  SchedulerBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  });
}
