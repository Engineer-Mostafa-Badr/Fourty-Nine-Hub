import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TabWidget extends StatelessWidget {
  const TabWidget({super.key, required this.title, this.count, required this.selected, required this.onTap, this.textSize});
  final String title;
  final int? count;
  final bool selected;
  final Function() onTap;
  final double? textSize;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap == null ? null : () {
        ManageVibration.vibrate();
        onTap!.call();
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10.h),
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.h),
                color: selected
                    ? AppColors.getButtonPrimaryColor(context)
                    : AppColors.getFillColor(context),
                border: Border.all(
                    color: AppColors.getButtonPrimaryColor(context),
                    width: 2)),
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Styles.headerText(
                    fontSize: textSize ?? 24,
                    color: selected
                        ? context.isDarkMode
                        ? Colors.black
                        : Colors.white
                        : AppColors.getTextColor(context)),
              ),
            ),
          ),
          Visibility(
            visible: (count??0) > 0,
            child: Positioned(
              top: -3.h,
              right: 4.h,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.getRedColor(context)),
                child: Center(
                  child: Text(
                    count.toString(),
                    style: Styles.smallText(
                        color: context.isDarkMode
                            ? Colors.black
                            : AppColors.whiteColor,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
