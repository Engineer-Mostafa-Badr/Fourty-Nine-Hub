import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../ads_feature/filter_ads/presentation/pages/widgets/custom_text_field.dart';

class CaptainRideDetails extends StatelessWidget {
  const CaptainRideDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(
          'Ride Details',
          style: TextStyle(
              fontSize: 50.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Captain ride with \nYou',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Feb 13 - 12:41 PM',
                        style: TextStyle(
                          fontSize: 30.sp,
                          color: AppColors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        '150 EGP',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SvgPicture.asset(Assets.carIcon)
                ],
              ),
              const SizedBox(height: 16),
              rideLocation(
                'Cairo International Airport',
                '12:10 PM',
                Assets.circleGreen,
              ),
              rideLocation(
                'Cairo International Airport',
                '12:41 PM',
                Assets.circleBlue,
              ),
              const SizedBox(height: 16),
              ratingSection('You rate 1st client'),
              const SizedBox(height: 5),
              ratingSection('You rate 2nd client'),
              const SizedBox(height: 5),
              ratingSection('You rate 3rd client'),
              const SizedBox(height: 16),
              ratingSection('First client rate you', isModifiable: false),
              SizedBox(height: 30.h),
              ratingSection('Second client rate you', isModifiable: false),
              SizedBox(height: 30.h),
              ratingSection('Third client rate you', isModifiable: false),
              const SizedBox(height: 16),
              MyTextField(
                fillColor: Color(0xffF5F5F5),
                noBorder: true,
                hint: "Write your problem",
                borderRadius: BorderRadius.circular(20),
              ),
              const SizedBox(height: 8),
              MyTextField(
                fillColor: Color(0xffF5F5F5),
                noBorder: true,
                hint: "Write your phone number",
                //     borderRadius: BorderRadius.circular(20),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.PRIMARY_COLOR,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {},
                  child: const Text('Request emergency support',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rideLocation(String title, String time, String icon) {
    return ListTile(
      leading: SvgPicture.asset(icon),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 28.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
      subtitle: Text(
        'Heliopolis, El Nozha, Cairo Governorate',
        style: TextStyle(
          fontSize: 25.sp,
          color: AppColors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Text(
        time,
        style: TextStyle(
          fontSize: 28.sp,
          color: AppColors.black,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget ratingSection(String text, {bool isModifiable = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        Row(
          children: [
            const Text('Good', style: TextStyle(fontSize: 16)),
            RatingBarIndicator(
              rating: 3,
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: 20,
              direction: Axis.horizontal,
            ),
            const SizedBox(width: 8),
            if (isModifiable)
              Container(
                width: 100.w,
                height: 75.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Color(0xffF3F3F3),
                ),
                child: Center(
                    child: Text(
                  "Modify",
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                )),
              )
          ],
        ),
      ],
    );
  }
}
