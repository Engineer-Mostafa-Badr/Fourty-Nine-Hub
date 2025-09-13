import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/widget/counter_widget.dart';
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
    this.height,
    this.bottom,
    this.top,
    this.start,
    this.end,
  });

  final Widget icon;
  final int unreadCount;
  final double? height;
  final double? bottom;
  final double? top;
  final double? start;
  final double? end;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: height ?? 40,
          // margin: unreadCount==0?null:const EdgeInsetsDirectional.only(
          //     top: 16, end: 8, start: 8, bottom: 8),

          // padding: const EdgeInsetsDirectional.only(top: 16,end: 8,start: 8,bottom: 8),
          child: icon,
        ),
        Visibility(
          visible: unreadCount != 0,
          child: PositionedDirectional(
            // top: 17.h,
            bottom: bottom ?? 17.h,
            start: start ?? 15.w,

            // end: 5,
            child: CounterWidget(
              unreadCount: unreadCount,
            ),
          ),
        )
      ],
    );
  }
}
