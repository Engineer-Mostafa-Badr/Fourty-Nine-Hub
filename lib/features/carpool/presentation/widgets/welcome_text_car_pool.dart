import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

List<Widget> welcomeTextCarPool(BuildContext context) {
  return [
    Text(
      "Welcome To Car Pool",
      style: Styles.headerText(
        // fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.getSecondryColor(context),
      ),
    ),
    const Sizer(),
    Text(
      "You don't have a car, You will initiate a route and waiting for one hour to give users time to book a seat in the same car",
      style: Styles.headerText(fontWeight: FontWeight.w400),
    ),
  ];
}
