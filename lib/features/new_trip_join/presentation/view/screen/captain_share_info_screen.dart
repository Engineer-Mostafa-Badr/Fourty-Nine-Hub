import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../routes/routes.dart';
import '../../../../trip_join/add_new_trip_join/presentation/views/widgets/button.dart';

class CaptainShareInfoScreen extends StatelessWidget {
  const CaptainShareInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          context.push(Routes.tripJoinInfoScreen);
        },
        child: Container(
          width: 150,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: AppColors.PRIMARY_COLOR,
          ),
          child: const CustomButton(
            title: 'Join Now!',
          ),
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
      body: const CaptainShareInfoBody(),
    );
  }
}

class CaptainShareInfoBody extends StatelessWidget {
  const CaptainShareInfoBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30.h),
          const Text(
            '! Captain Share',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.PRIMARY_COLOR,
            ),
          ),
          SizedBox(height: 20.h),
          SvgPicture.asset(Assets.captainInfoIcon),
          SizedBox(height: 30.h),
          const RowTextWidget(text: 'Save money & Book 1 seat.'),
          const RowTextWidget(text: 'Heading final destination.'),
          const RowTextWidget(
              text: 'Wait for others to share route seats with '),
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
                fontSize: 17, // ضبط الحجم ليكون قريبًا من الصورة
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
