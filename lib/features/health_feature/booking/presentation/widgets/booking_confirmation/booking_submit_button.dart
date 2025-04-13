import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';

class BookingButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  const BookingButton({super.key, required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return   GestureDetector(
      onTap: onTap,
      child: Container(
        width: 686.w,
        height: 80.h,
        decoration: BoxDecoration(
          color: AppColors.PRIMARY_COLOR,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Center(
          child: Text(
            title,
            style: Styles.headerText(color: AppColors.whiteColor),
          ),
        ),
      ),
    );
  }
}
