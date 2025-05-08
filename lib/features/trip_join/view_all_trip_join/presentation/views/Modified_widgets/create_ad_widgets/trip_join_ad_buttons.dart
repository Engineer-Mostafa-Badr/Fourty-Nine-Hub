import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';


class PremiumAndRequestWidget extends StatelessWidget {
  const PremiumAndRequestWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.getRedColor(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {},
            child: Center(
              child: Text(
                context.isArabic?'نشر مميز':'Premium Publish',
                style:Styles.headerText(color:context.isDarkMode?Colors.black: Colors.white,
                  fontWeight: FontWeight.bold, fontSize: 30)
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:AppColors.getButtonPrimaryColor(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {},
            child: Center(
              child: Text(
                LocaleKeys.publish.localize,
                style: Styles.headerText(color:context.isDarkMode?Colors.black: Colors.white,
                  fontWeight: FontWeight.bold,fontSize: 30),
              ),
            ),
          ),
        ),
      ],
    );
  }
}