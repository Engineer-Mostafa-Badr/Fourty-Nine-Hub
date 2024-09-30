import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../res/style/styles.dart';

class IconWithViewCount extends StatelessWidget {
  const IconWithViewCount({
    super.key,
    required this.icon,
    required this.unreadCount,
    this.spaceBetween = 5,
  });
  final Widget icon;
  final int unreadCount;
  final double spaceBetween;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Tab(
          icon: icon,
        ),
        Sizer(width: spaceBetween.w),
        Text(
          unreadCount == 0 ? '   ' : '($unreadCount)',
          style: Styles.mediumText(color: AppColors.SECONDARY_COLOR),
        ),
      ],
    );
  }
}
