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
          _formatCount(unreadCount),
          style: Styles.mediumText(color: AppColors.SECONDARY_COLOR),
        ),
      ],
    );
  }

  String _formatCount(int? count) {
    // count = 1009;
    if (count == null || count == 0) {
      return '  ';
    }
    if (count < 1000) {
      return '($count)';
    }
    String result = (count / 1000).toStringAsFixed(1);
    if (result.endsWith('0')) {
      return "(${result.split('.').first}K)";
    }
    return '(${result}K)';
  }
}
