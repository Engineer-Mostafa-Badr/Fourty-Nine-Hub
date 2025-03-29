import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/style/styles.dart';

List<Widget> cardTitleAndInfo({required String title}) {
  return [
    Text(
      title,
      style: Styles.headerText(fontSize: 24.sp, textAlign: TextAlign.start),
    ),
    Text(
      'Location Suggestion',
      style: Styles.headerText(fontSize: 20.sp, textAlign: TextAlign.start),
    ),
    Text(
      'Please Choose the address that match what you are searching for',
      style: Styles.mediumText(fontSize: 14.sp, fontWeight: FontWeight.w300),
    ),
  ];
}
