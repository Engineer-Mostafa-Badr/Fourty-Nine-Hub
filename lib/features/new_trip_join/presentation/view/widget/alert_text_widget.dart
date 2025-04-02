import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class AlertTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;

  const AlertTextWidget({
    super.key,
    required this.text,
    this.fontSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.circle,
          color: Colors.black,
          size: fontSize * 0.3, // حجم الأيقونة مناسب للنص
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.black,
              fontSize: fontSize.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
