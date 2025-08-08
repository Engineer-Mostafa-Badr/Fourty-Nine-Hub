import 'package:flutter/material.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

List<Widget> welcomeTextdontOwnCar(BuildContext context) {
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
      LocaleKeys.dontOwnCar.localize.trim(),
      style: Styles.headerText(fontWeight: FontWeight.w400),
    ),
  ];
}
