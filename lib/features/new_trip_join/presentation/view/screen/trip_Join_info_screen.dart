import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../routes/routes.dart';
import 'pick_me_info_screen.dart';

class TripJoinInfoScreen extends StatelessWidget {
  const TripJoinInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          context.push(Routes.pickMeInfoScreen);
        },
        child: Container(
          width: 300.w,
          height: 80.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: AppColors.PRIMARY_COLOR,
          ),
          child: Center(
            child: Text(
              "Start Journey!",
              style: TextStyle(
                fontSize: 32.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: HomeAppbar(
          isWithBackArrow: false,
          language: true,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ),
      ),
      body: const TripJoinInfoInfoBody(),
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
        const Text(
          'Trip Join!',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.PRIMARY_COLOR,
          ),
        ),
        SizedBox(height: 20.h),
        SvgPicture.asset(Assets.tripInfoIcon),
        SizedBox(height: 30.h),
        const RowTextWidget(text: 'You are a car Owner.'),
        SizedBox(height: 15.h),
        const RowTextWidget(text: 'Advertise your daily repeat trip.'),
        SizedBox(height: 15.h),
        const RowTextWidget(text: 'Wait for users to contact you.'),
        SizedBox(height: 15.h),
        const RowTextWidget(text: 'Share your trip & gain money.'),
      ],
    );
  }
}
