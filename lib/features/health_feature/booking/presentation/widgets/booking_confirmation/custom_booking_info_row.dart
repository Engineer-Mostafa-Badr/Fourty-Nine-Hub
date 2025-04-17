import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';

import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';

class CustomBookingInfoRow extends StatelessWidget {
  final String? fees;
  final IconData icon;
  final String title;
  final Color? bgColor;
  final BuildContext context;
  final  bool isBordered ;
  const CustomBookingInfoRow({
    super.key,
    this.fees,
    this.isBordered=false,
    required this.icon,
    required this.title,
    required this.context, this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 686.w,
      height: 88.h,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: isBordered?AppColors.black:Colors.transparent),
        color:bgColor?? AppColors.BG_GRAY_COLOR,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: fees != null
                ? SvgPicture.asset(Assets.cash)
                : Icon(icon, color: AppColors.PRIMARY_COLOR, size: 48.sp),
          ),
          Expanded(
            flex: 7,
            child: Text(
              title,
              style: fees != null
                  ? Styles.headerText(color: AppColors.PRIMARY_COLOR)
                  : Styles.mediumText(color: AppColors.black),
            ),
          ),
          if (fees != null)
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Text(
                    fees!,
                    style: Styles.headerText(color: AppColors.PRIMARY_COLOR),
                  ),
                  const Sizer(width: 2,)
                ],
              ),
            ),
        ],
      ),
    );
  }
}
