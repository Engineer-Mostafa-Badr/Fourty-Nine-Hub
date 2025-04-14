import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:path/path.dart';

import 'health_contacts_button.dart';

class FavouriteAdsCard extends StatelessWidget {
  final VoidCallback onFavourite;
  final VoidCallback onRequest;

  const FavouriteAdsCard(
      {super.key,required this.onFavourite, required this.onRequest});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800.w,
      height: 500.h,
      margin: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image + heart icon + Premium label
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                child: Image.asset(
                  'assets/images/doctor_profile.jpeg',
                  // Replace with real image
                  height: 220.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10.h,
                left: 10.w,
                child: IconButton(
                    onPressed: onFavourite,
                    icon: Icon(Icons.favorite, color: Colors.red, size: 70.sp)),
              ),
              Positioned(
                top: 10.h,
                right: 10.w,
                child: Text(
                  LocaleKeys.premium.localize,
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
              style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold),
            ),
          ),

          /// Rating + Location
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,

              children: [
               Label(text: LocaleKeys.google.localize,style: Styles.mediumText(fontWeight: FontWeight.w500),),
                SizedBox(width: 10.w),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.location_on, size: 50.sp, color: AppColors.PRIMARY_COLOR),
                Label(text:"Giza , Egypt", style: Styles.mediumText()),

              ],
            ),
          ),

          /// Availability
          Padding(
            padding: EdgeInsets.only(left: 20.w, top: 10.h),
            child: Label(text: LocaleKeys.available.localize,style: Styles.mediumText(color: AppColors.colorRed),)
          ),

/// request - contact buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Request button
                Expanded(
                  flex: 4,
                  child: Container(
                    padding:EdgeInsets.symmetric(horizontal: 50.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17.r),
                      color: AppColors.colorRed
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Label(
                        text: LocaleKeys.request.localize,
                        style: Styles.headerText(color: AppColors.whiteColor),
                      ),
                    ),
                  ),
                ),
                Sizer(height: 15),
                Expanded(
                  flex: 6,
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
    );
  }
}
