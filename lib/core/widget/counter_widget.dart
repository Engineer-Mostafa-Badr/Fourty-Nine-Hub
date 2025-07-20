import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class CounterWidget extends StatelessWidget {
  const CounterWidget(
      {super.key,
      required this.unreadCount,
      this.width,
      this.height,
      this.borderWidth,
      this.fontSize,
      this.bgColor,
      this.txtColor,
      this.borderColor});

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
      width: width??42.w,
      height: height??42.w,
      // padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          border: Border.all(
              color: borderColor ?? AppColors.getReversedTextColor(context),
              width: borderWidth ?? 1.w),
          shape: BoxShape.circle,
          color: bgColor ?? AppColors.getRedColor(context)),
      alignment: AlignmentDirectional.center,
      child: AutoSizeText(
        formatNumber(unreadCount, isArabic: context.isArabic),
        style: TextStyle(
          fontSize: fontSize ?? 4.sp,
          color: txtColor ?? AppColors.getReversedTextColor(context),
        ),
        maxLines: 1,
        minFontSize: 6,
        stepGranularity: 0.5,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }

  String formatNumber(num number, {bool isArabic = false}) {
    String suffix = '';
    String result = '';

    if (number >= 1e9) {
      result =
          (number / 1e9).toStringAsFixed(1).replaceAll(RegExp(r"\.0$"), '');
      suffix = 'B';
    } else if (number >= 1e6) {
      result =
          (number / 1e6).toStringAsFixed(1).replaceAll(RegExp(r"\.0$"), '');
      suffix = 'M';
    } else if (number >= 1e3) {
      result =
          (number / 1e3).toStringAsFixed(1).replaceAll(RegExp(r"\.0$"), '');
      suffix = 'K';
    } else {
      result = number.toString();
    }

    return '$result$suffix';
  }
}
