import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class FindLocationButton extends StatelessWidget {
  const FindLocationButton({
    super.key,
    this.onTap,
    this.height = 60,
    this.title = 'From', this.width=200,
  });
  final void Function()? onTap;
  final double height;
  final double width;
  final String title;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.PRIMARY_COLOR.withOpacity(0.6),
      radius: 45,
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.PRIMARY_COLOR.withOpacity(0.6),
          borderRadius: BorderRadius.circular(30.h),
        ),
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.h),
            color: AppColors.PRIMARY_COLOR,
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: Styles.headerText(color: Colors.white,fontSize: 28),
          ),
        ),
      ),
    );
  }
}
