import 'package:flutter/material.dart';
import 'package:marquee_text/marquee_text.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/const.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdsTextBanner extends StatelessWidget {
  const AdsTextBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.symmetric(vertical: 5.h),
      decoration: const BoxDecoration(color: AppColors.SECONDARY_COLOR),
      child:  MarqueeText(
        text: const TextSpan(
          text: UIConst.placeholderText,
        ),
        style: TextStyle(
          fontSize: 24.sp,
          color: Colors.white,
        ),
        speed: 30,
      ),
    );
  }
}
