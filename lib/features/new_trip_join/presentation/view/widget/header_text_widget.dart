import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

class HeaderTextWidget extends StatelessWidget {
  const HeaderTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      LocaleKeys.oneWayOneCaptain.localize,
      style: TextStyle(
        color: context.isDarkMode ? Colors.white : const Color(0xffFF0808),
        fontWeight: FontWeight.bold,
        fontSize: 30.sp,
      ),
    );
  }
}
