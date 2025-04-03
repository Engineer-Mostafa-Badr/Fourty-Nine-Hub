import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onTap,
    this.height = 60,
    this.color = AppColors.PRIMARY_COLOR,
    this.title = 'Find',
  });
  final void Function()? onTap;
  final double height;
  
  final String title;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.PRIMARY_COLOR.withOpacity(0.6),
      radius: 15,
      child: Ink(
        decoration: BoxDecoration(
          color:color.withOpacity(0.6),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          height: height,
          width: 200.w,
          //  padding: EdgeInsets.symmetric(vertical: 7.5.h, horizontal: 30.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: color,
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: Styles.headerText(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
