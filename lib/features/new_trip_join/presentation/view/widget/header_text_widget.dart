import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class HeaderTextWidget extends StatelessWidget {
  const HeaderTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      LocaleKeys.oneWayOneCaptain.localize,
      style: TextStyle(
        color: AppColors.getRedColor(context),
        fontWeight: FontWeight.bold,
        fontSize: 30.sp,
      ),
    );
  }
}
