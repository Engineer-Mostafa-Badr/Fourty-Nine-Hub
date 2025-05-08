import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
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
                        context.isArabic ? "150 ج.م" : '150 EGP',
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
                context,
                context.isArabic
                    ? "مطار القاهرة الدولي"
                    : 'Cairo International Airport',
                context.isArabic ? "12:10 م" : '12:10 PM',
               Colors.green,
              ),
              rideLocation(
                context,
                context.isArabic
                    ? "مطار القاهرة الدولي"
                    : 'Cairo International Airport',
                context.isArabic ? "12:10 م" : '12:10 PM',
                Colors.blue,
              ),
              const SizedBox(height: 16),
              ratingSection(
                context,
                context.isArabic
                    ? "تقييمك للعميل الأول"
                    : 'You rate 1st client',
                isRated: false,
              ),
              const SizedBox(height: 5),
              ratingSection(
                context,
                context.isArabic
                    ? "تقييمك للعمل الثاني"
                    : 'You rate 2nd client',
                isRated: false,
              ),
              const SizedBox(height: 5),
              ratingSection(
                context,
                context.isArabic
                    ? "تقييمك للعميل الثالث "
                    : 'You rate 3rd client',
                isRated: false,
              ),
              const SizedBox(height: 16),
              ratingSection(
                context,
                context.isArabic
                    ? "تقييم العميل الاول لك"
                    : 'First client rate you',
                isModifiable: false,
              ),
              SizedBox(height: 30.h),
              ratingSection(
                context,
                context.isArabic
                    ? "تقييم العميل الثاني لك"
                    : 'Second client rate you',
                isModifiable: false,
              ),
              SizedBox(height: 30.h),
              ratingSection(
                context,
                context.isArabic
                    ? "تقييم العميل الثالث لك"
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
                AppColors.getFillColor(context),
                borderRadius: BorderRadius.circular(15),
                borderSide: AppColors.getFillColor(context),
                textStyle: Styles.mediumText(color: AppColors.getTextColor(context)),
                borderColor: AppColors.getFillColor(context),

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
                AppColors.getFillColor(context),
                borderRadius: BorderRadius.circular(15),
                borderSide: AppColors.getFillColor(context),
                type: TextInputType.phone,
                textStyle: Styles.mediumText(color: AppColors.getTextColor(context)),
                borderColor: AppColors.getFillColor(context),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.getButtonPrimaryColor(context),
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
                        color:context.isDarkMode?Colors.black: Colors.white,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rideLocation(BuildContext context,String title, String time, Color color) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity:const  VisualDensity(horizontal: -4,vertical: -4),
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: CircleAvatar(
          backgroundColor: color,
          radius: 10,
          child: CircleAvatar(
              backgroundColor: AppColors.getFillColor(context), radius: 5),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 28.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        context.isArabic?'هليوبليس ،النزهة ,القاهرة':'Heliopolis, El Nozha, Cairo Governorate',
        style: TextStyle(
          fontSize: 25.sp,
          fontWeight: FontWeight.w400,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
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
      BuildContext context,
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
                  Text(
                    context.isArabic?'جيد':"Good",
                    style:const TextStyle(
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
                  color: AppColors.getFillColor(context)
                ),
                child: Center(
                  child: Text(
                    LocaleKeys.rate.localize,
                    style: TextStyle(
                      color: AppColors.getTextColor(context),
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
