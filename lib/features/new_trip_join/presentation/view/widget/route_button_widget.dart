import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:go_router/go_router.dart';

import '../../../../../res/assets/assets.dart';
import '../../../../../routes/routes.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class RouteButtonWidget extends StatelessWidget {
  const RouteButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 1),
          child: GestureDetector(
            onTap: () {
      ManageVibration.vibrate();
              context.push(Routes.captainShareInfoScreen);
            },
            child: Container(
              height: 50.h,
              width: 70.w,
              decoration: const BoxDecoration(
                color: Color(0xff0B1035),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                size: 19,
                Icons.question_mark,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
      ManageVibration.vibrate();
            context.push(Routes.newRouteScreen);
          },
          child: Container(
            width: 344.w,
            height: 75.h,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Color(0xff0B1035),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(Assets.addIcon),
                SizedBox(width: 10.w),
                Text(
                  LocaleKeys.createRoute.localize,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}