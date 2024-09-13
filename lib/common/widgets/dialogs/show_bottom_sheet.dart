import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void bottomSheet(
    {required BuildContext context,
    required Widget widget,
    Color? backColor,
    bool isFloating = false,
    bool isScrollControlled = false}) async {
  showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(30.w),
          // margin: EdgeInsets.all(kToolbarHeight),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
            color: backColor ?? Theme.of(context).dialogBackgroundColor,
          ),
          child: widget,
        );
      });
}
