import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class TimeCard extends StatelessWidget {
  final String timeUnit;
  final String value;

  const TimeCard({
    super.key,
    required this.timeUnit,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      height: 90.h,
      decoration:  BoxDecoration(
          boxShadow: AppColors.SHADOW_LIGHT,
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: Styles.mediumText(
                fontSize: 65.sp,
                fontWeight: FontWeight.bold
            ),
          ),
          Text(
            timeUnit,
            style:Styles.smallText(
              fontSize: 60.sp,
            ),
          ),
        ],
      ),
    );
  }
}
