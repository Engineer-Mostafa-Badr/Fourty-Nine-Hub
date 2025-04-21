import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/form/text_fields/form_text_field.dart';

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
          LocaleKeys.rideDetails.localize,
          style: TextStyle(
            fontSize: 50.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.isArabic ? "كابتن يركب معك" : 'Captain ride with \nYou',
                style: TextStyle(
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
                        context.isArabic
                            ? "13 فبراير - 12:41 مساءً"
                            : 'Feb 13 - 12:41 PM',
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        context.isArabic ? "150 جنيه مصري" : '150 EGP',
                        style: TextStyle(
                          color: context.isDarkMode
                              ? Colors.white
                              : AppColors.PRIMARY_COLOR,
                          fontSize: 32.sp,
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
                context.isArabic
                    ? "مطار القاهرة الدولي"
                    : 'Cairo International Airport',
                context.isArabic ? "12:10 مساءً" : '12:10 PM',
                Assets.circleGreen,
              ),
              rideLocation(
                context.isArabic
                    ? "مطار القاهرة الدولي"
                    : 'Cairo International Airport',
                context.isArabic ? "12:10 مساءً" : '12:10 PM',
                Assets.circleBlue,
              ),
              const SizedBox(height: 16),
              ratingSection(
                context.isArabic
                    ? "أنت تقيم العميل الأول"
                    : 'You rate 1st client',
                isRated: false,
              ),
              const SizedBox(height: 5),
              ratingSection(
                context.isArabic
                    ? "أنت تقيم العميل التاني"
                    : 'You rate 2nd client',
                isRated: false,
              ),
              const SizedBox(height: 5),
              ratingSection(
                context.isArabic
                    ? "أنت تقيم العميل الثالث "
                    : 'You rate 3rd client',
                isRated: false,
              ),
              const SizedBox(height: 16),
              ratingSection(
                context.isArabic
                    ? "العميل الأول الذي قيمك"
                    : 'First client rate you',
                isModifiable: false,
              ),
              SizedBox(height: 30.h),
              ratingSection(
                context.isArabic
                    ? "العميل الثاني الذي قيمك"
                    : 'Second client rate you',
                isModifiable: false,
              ),
              SizedBox(height: 30.h),
              ratingSection(
                context.isArabic
                    ? "العميل الثالث الذي قيمك"
                    : 'Third client rate you',
                isModifiable: false,
              ),
              const SizedBox(height: 16),
              FormTextField(
                style: TextStyle(
                  color:
                      context.isDarkMode ? Colors.white : Colors.grey.shade600,
                ),
                hint: context.isArabic ? "اكتب مشكلتك" : "Write your problem",
                fillColor:
                    context.isDarkMode ? Colors.white : const Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(15),
              ),
              const SizedBox(height: 16),
              FormTextField(
                style: TextStyle(
                  color:
                      context.isDarkMode ? Colors.white : Colors.grey.shade600,
                ),
                hint: context.isArabic
                    ? "اكتب رقم هاتفك"
                    : "Write your phone number",
                fillColor:
                    context.isDarkMode ? Colors.white : const Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(15),
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
                  child: Text(
                      context.isArabic
                          ? "طلب الدعم في حالات الطوارئ"
                          : 'Request emergency support',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      )),
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
        ),
      ),
      subtitle: Text(
        'Heliopolis, El Nozha, Cairo Governorate',
        style: TextStyle(
          fontSize: 25.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Text(
        time,
        style: TextStyle(
          fontSize: 28.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget ratingSection(
    String text, {
    bool isModifiable = true,
    bool isRated = true,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          children: [
            if (isRated)
              Row(
                children: [
                  const Text(
                    "Good",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
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
                ],
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
                    LocaleKeys.rate.localize,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )
          ],
        ),
      ],
    );
  }
}
