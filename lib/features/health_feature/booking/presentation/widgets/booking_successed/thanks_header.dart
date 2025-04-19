import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';

class ThanksHeader extends StatelessWidget {
  const ThanksHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 35.w),
          child: Row(
            children: [
              Text(
                "Thank You".localize,
                style: Styles.headerText(
                    fontSize: 40, color: AppColors.black),
              ),
              const Spacer(),
            ],
          ),
        ),
        Column(
          children:  [
            const Sizer(height: 30,),
            CircleAvatar(
              radius: 160.r,
              backgroundColor: AppColors.RIGHT_SGIN,
              child: Icon(Icons.check, color: Colors.white, size: 160.sp),
            ),
           const Sizer(height: 12),
            Text(
              "Your booking is successful",
              style:Styles.headerText(
    color: AppColors.GREY_DARK_COLOR
    ),),
            Text(
              "Dr. Ibrahim Ahmed",
              style:Styles.headerText(
    color: AppColors.GREY_DARK_COLOR
    ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}
