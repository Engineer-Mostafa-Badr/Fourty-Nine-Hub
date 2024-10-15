import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class SubscribeButtonWidget extends StatelessWidget {
  const SubscribeButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return    SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)),
          padding:
          EdgeInsets.symmetric(horizontal: 40.w, vertical: 25.h),
          backgroundColor: AppColors.SECONDARY_COLOR,
        ),
        child: Text(
            LocaleKeys.subscribe.localize,
            style: Styles.mediumText(
                color: Colors.white,
                fontSize: 55.sp,
                fontWeight: FontWeight.w400
            )),
      ),
    );
  }
}
