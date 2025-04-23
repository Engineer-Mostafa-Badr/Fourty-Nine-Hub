import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'health_contacts_button.dart';

class FavouriteAdsCard extends StatelessWidget {
  final VoidCallback onFavourite;
  final VoidCallback onRequest;
  final String SubType;

  const FavouriteAdsCard(
      {super.key,
      required this.onFavourite,
      required this.onRequest,
      required this.SubType});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 800.w,
          height: 640.h,
          margin: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            border: Border.all(color: AppColors.black),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Image + heart icon + Premium label
              Stack(
                children: [
                  Column(
                    children: [
                      Sizer(
                        height: 60,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.r),
                        ),
                        child: Image.asset(
                          'assets/images/doctor_profile.jpeg',
                          // Replace with real image
                          height: 280.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 80.h,
                    left: 10.w,
                    child: IconButton(
                        onPressed: onFavourite,
                        icon: Icon(Icons.favorite, color: Colors.red, size: 70.sp)),
                  ),
                  Positioned(
                    top: 10.h,
                    right: 20.w,
                    child: Text(
                      SubType,
                      style: Styles.headerText(),
                    ),
                  ),
                ],
              ),

              /// Clinic Name
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Text(
                  "Misr Modern Clinic",
                  style: Styles.headerText(),
                ),
              ),

              /// Rating + Location
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Label(
                      text: LocaleKeys.good.localize,
                      style: Styles.mediumText(
                          fontWeight: FontWeight.w600, fontSize: 35),
                    ),
                    Sizer(width: 10),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < 3 ? Icons.star : Icons.star_border,
                          size: 40.sp,
                          color: Colors.amber,
                        );
                      }),
                    ),
                  ],
                ),
              ),

              /// Avalibility
              Padding(
                padding: EdgeInsets.only(right: 20.w, left: 20, top: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Label(
                          text: LocaleKeys.available.localize,
                          style: Styles.mediumText(
                              color: AppColors.colorRed,
                              fontWeight: FontWeight.w600),
                        )),
                    Spacer(),
                    Icon(Icons.location_on,
                        size: 40.sp, color: AppColors.PRIMARY_COLOR),
                    Label(text: "Giza , Egypt", style: Styles.mediumText()),
                  ],
                ),
              ),

              Sizer(
                height: 30,
              ),

              /// request - contact buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Request button
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 80.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.r),
                          color: AppColors.colorRed),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Label(
                          text: LocaleKeys.request.localize,
                          style: Styles.mediumText(color: AppColors.whiteColor),
                        ),
                      ),
                    ),
                    Sizer(
                      width: 50,
                    ),
                    Expanded(
                      child: HealthContactsButtons(
                        otherUserId: '',
                        subcategoryId: '',
                        phone: '',
                        id: "",
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SubType==LocaleKeys.notSubscribed.localize?
        Label(text: LocaleKeys.pleaseSubscribeToContactTheClient,style: Styles.headerText(color: AppColors.colorRed),):SizedBox()
      ],
    );
  }
}
