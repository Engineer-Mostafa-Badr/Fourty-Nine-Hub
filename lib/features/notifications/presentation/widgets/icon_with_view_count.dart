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

class CustomNotificationWidget extends StatelessWidget {
  const CustomNotificationWidget({
    super.key,
    required this.icon,
    required this.unreadCount,
  });

  final Widget icon;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsetsDirectional.only(top: 16,end: 8,start: 8,),
          child: icon,
        ),
        Visibility(
          visible: unreadCount != 0,
          child: Positioned(
            top: 6,
            right: -5,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColors.SECONDARY_COLOR),
              child: Center(
                child: Text(
                  unreadCount == 0 ? '   ' : '$unreadCount',
                  style: Styles.smallText(
                      color: AppColors.whiteColor, fontSize: 20),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
