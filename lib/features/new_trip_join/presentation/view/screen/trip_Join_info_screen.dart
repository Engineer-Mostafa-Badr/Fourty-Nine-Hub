import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';

import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../routes/routes.dart';
import '../../../captainshare/screen/captain_share_info_screen.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class TripJoinInfoScreen extends StatelessWidget {
  const TripJoinInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      onBackPressed: () => context.pop(),
      floatingActionButton: GestureDetector(
        onTap: () {
          ManageVibration.vibrate();
          context.pop();
        },
        child: Container(
          width: 300.w,
          height: 80.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: AppColors.getButtonPrimaryColor(context),
          ),
          child: Center(
            child: Text(
              context.isArabic ? "بدء الرحلة!" : "Start Journey!",
              style: TextStyle(
                fontSize: 32.sp,
                color: context.isDarkMode ? AppColors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: const TripJoinInfoInfoBody(),
      mainCategoryId: 1,
    );
  }
}

class TripJoinInfoInfoBody extends StatelessWidget {
  const TripJoinInfoInfoBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 30.h),
        Text(
          context.isArabic ? "جاي معاك !" : 'Trip Join !',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
          ),
        ),
        SizedBox(height: 20.h),
        context.isDarkMode
            ? Image.asset(
                Assets.tripDarkInfoIcon,
                height: MediaQuery.of(context).size.height * 0.4,
                fit: BoxFit.cover,
              )
            : SvgPicture.asset(Assets.tripInfoIcon),
        SizedBox(height: 30.h),
        RowTextWidget(
          text: context.isArabic ? "أنت مالك السيارة." : 'You are a car Owner.',
        ),
        SizedBox(height: 15.h),
        RowTextWidget(
            text: context.isArabic
                ? "قم بالإعلان عن رحلتك المتكررة يوميًا."
                : 'Advertise your daily repeat trip.'),
        SizedBox(height: 15.h),
        RowTextWidget(
          text: context.isArabic
              ? "انتظر حتى يتواصل معك المستخدمون."
              : 'Wait for users to contact you.',
        ),
        SizedBox(height: 15.h),
        RowTextWidget(
          text: context.isArabic
              ? "شارك رحلتك واكسب المال."
              : 'Share your trip & gain money.',
        ),
      ],
    );
  }
}
