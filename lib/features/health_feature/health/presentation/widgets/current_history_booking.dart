import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CurrentHistoryBooking extends StatelessWidget {
  const CurrentHistoryBooking({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context, ) {
    return GestureDetector(
      onTap:(){ } ,
      child: Container(
        margin: EdgeInsets.only(top:10.h),
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(
          vertical: 12.h,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.h),
            color: AppColors.GREYBG,
            border: Border.all(
                color:AppColors.PRIMARY_COLOR,
                width: 2)),
        child: Center(
          child: Text(
            title.localize,
            style: Styles.headerText(
                fontSize: 24,
                color:AppColors.black),
          ),
        ),
      ),
    );
  }
}
