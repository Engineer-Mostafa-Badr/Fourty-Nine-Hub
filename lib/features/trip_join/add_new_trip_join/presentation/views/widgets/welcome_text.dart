import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

List<Widget> welcomeText(BuildContext context) {
  return [
    Text(
      LocaleKeys.welcomeToTripjoin.localize,
      style: Styles.headerText(
        // fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.getSecondryColor(context),
      ),
    ),
    const Sizer(),
    Text(
      LocaleKeys.ownCar.localize.trim(),
      style: Styles.headerText(fontWeight: FontWeight.w400),
    ),
  ];
}
