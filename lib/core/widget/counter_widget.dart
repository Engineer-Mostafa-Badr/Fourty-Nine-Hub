import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CounterWidget extends StatelessWidget {
  const CounterWidget({super.key, required this.unreadCount, this.width, this.height, this.borderWidth, this.fontSize, this.bgColor, this.txtColor, this.borderColor});
  final int unreadCount;
  final double? width;
  final double? height;
  final double? borderWidth;
  final double? fontSize;
  final Color? bgColor;
  final Color? txtColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width??40.w,
      height: height??40.w,
      // padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          border: Border.all(
            color: borderColor??AppColors.getReversedTextColor(context),
            width: borderWidth??1.w
          ),
          shape: BoxShape.circle, color:bgColor?? AppColors.getRedColor(context)),
      alignment: AlignmentDirectional.center,
      child: Center(
        child: Text(
          unreadCount == 0 ? '   ' : '$unreadCount',
          style: Styles.smallText(
              color: txtColor??AppColors.getReversedTextColor(context), fontSize: fontSize??18),
        ),
      ),
    );
  }
}
