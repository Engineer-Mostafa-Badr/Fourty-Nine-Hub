import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class AlertTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;

  const AlertTextWidget({
    super.key,
    required this.text,
    this.fontSize = 26,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: fontSize * 0.15),
          child: Icon(
            Icons.circle,
            color: AppColors.getTextColor(context),
            size: fontSize * 0.4,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize.sp,
              fontWeight: FontWeight.w700,
              color:AppColors.getTextColor(context),
            ),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
