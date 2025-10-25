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
    print(
        "formatNumber(unreadCount, isArabic: context.isArabic) ${formatNumber(unreadCount, isArabic: context.isArabic)}");
    String arabicText = unreadCount
        .toString()
        .replaceAll('0', '٠')
        .replaceAll('1', '١')
        .replaceAll('2', '٢')
        .replaceAll('3', '٣')
        .replaceAll('4', '٤')
        .replaceAll('5', '٥')
        .replaceAll('6', '٦')
        .replaceAll('7', '٧')
        .replaceAll('8', '٨')
        .replaceAll('9', '٩');
    String englishText = unreadCount
        .toString()
        .replaceAll('٠', '0')
        .replaceAll('١', '1')
        .replaceAll('٢', '2')
        .replaceAll('٣', '3')
        .replaceAll('٤', '4')
        .replaceAll('٥', '5')
        .replaceAll('٦', '6')
        .replaceAll('٧', '7')
        .replaceAll('٨', '8')
        .replaceAll('٩', '9');
    return Container(
      width: width ?? 42.w,
      height: height ?? 42.w,
      // padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          border: Border.all(
              color: borderColor ?? AppColors.getReversedTextColor(context),
              width: borderWidth ?? 5.w),
          shape: BoxShape.circle,
          color: bgColor ?? AppColors.getRedColor(context)),
      alignment: AlignmentDirectional.center,
      child: AutoSizeText(
        context.isArabic ? arabicText : englishText,
        style: TextStyle(
          fontSize: fontSize ?? 20.sp,
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
