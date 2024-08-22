import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

List<Widget> welcomeText() {
  return [
    Text(
      'Welcome To Trip Join',
      style: Styles.headerText(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.SECONDARY_COLOR),
    ),
    const Sizer(),
    Text(
      'You have a car and are looking for someone to join you on your journey.',
      style: Styles.headerText(fontSize: 18, fontWeight: FontWeight.w400),
    ),
  ];
}
