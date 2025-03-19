import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';

class PickMeInfoScreen extends StatelessWidget {
  const PickMeInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Color(0xff0B1035),
        ),
        child: const Text(
          "Create Ride! ",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      appBar: HomeAppbar(
        isWithBackArrow: false,
        language: true,
        leading: IconButton(
          icon: const Icon(Icons.menu), // The menu icon
          onPressed: () {},
        ),
      ),
      body: const PickMeInfoInfoBody(),
    );
  }
}

class PickMeInfoInfoBody extends StatelessWidget {
  const PickMeInfoInfoBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30.h),
          const Text(
            'Pick me!',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.PRIMARY_COLOR,
            ),
          ),
          SizedBox(height: 20.h),
          SvgPicture.asset(Assets.pickMeInfoIcon),
          SizedBox(height: 30.h),
          const RowTextWidget(text: "Don't have a car?!"),
          const RowTextWidget(text: 'Tired from the expensive price.'),
          const RowTextWidget(text: 'Advertise your daily repeat trip.'),
          const RowTextWidget(text: 'Wait for car owners to contact you.'),
          const RowTextWidget(text: 'Share your trip & save money.'),
        ],
      ),
    );
  }
}

class RowTextWidget extends StatelessWidget {
  final String text;
  const RowTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.circle,
            size: 15.r,
            color: Colors.black,
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center, // توسيط النص على اليمين
              style: const TextStyle(
                fontSize: 18, // ضبط الحجم ليكون قريبًا من الصورة
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
