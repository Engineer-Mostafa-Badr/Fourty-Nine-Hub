import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../res/assets/assets.dart';

Widget tripOption(String imagePath, String title, void Function()? onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        SizedBox(height: 30.h),
        SvgPicture.asset(imagePath),
        SvgPicture.asset(Assets.shadowTripIcon),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
