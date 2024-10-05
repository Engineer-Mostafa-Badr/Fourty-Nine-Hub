import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class NumberWidget extends StatelessWidget {
  const NumberWidget({super.key, required this.number, this.size = 45});
  final int number;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: (size * 1.2).w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: AppColors.PRIMARY_COLOR,
      ),
      alignment: Alignment.center,
      child: Text(
        number.toString(),
        style: Styles.headerText(
          color: Colors.white,
          // fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
