import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class SubscribeViewBody extends StatelessWidget {
  const SubscribeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: context.screenHeight /3 ,
              width: context.screenWidth ,
              decoration:  BoxDecoration(
                boxShadow: AppColors.SHADOW_LIGHT,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Image.asset(
                'assets/images/doctor.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
           SizedBox(height: 20.h),
          Text(
            LocaleKeys.subscribe.localize,
            style: Styles.headerText(
                color: Theme.of(context).primaryColor, fontSize: 80.sp),
          ),
           SizedBox(height: 10.h),
          Text(
            'Type the value you want to participation',
            textAlign: TextAlign.center,
            style: Styles.mediumText(),
          ),
           SizedBox(height: 20.h),
          Text(
            'participation with points (points)',
            textAlign: TextAlign.center,
            style: Styles.mediumText(),
          ),
           SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding:  EdgeInsets.symmetric(
                        horizontal: 20.w, vertical: 25.h,
                    ),
                    backgroundColor: AppColors.PRIMARY_COLOR,
                  ),
                  child: Icon(
                    Icons.remove,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  )),
              const Spacer(),
              Container(
                width: context.screenWidth / 2,
                padding:
                     EdgeInsets.only(top: 3.h, bottom: 3.h, left: 2.w, right:25.w),
                decoration: BoxDecoration(
                  color: AppColors.PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {},
                    ),
                    const Spacer(),
                    Text('0',
                        style: Styles.mediumText(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          fontSize: 100.sp,
                        )),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding:  EdgeInsets.symmetric(
                      horizontal: 20.w, vertical: 25.h,
                    ),
                    backgroundColor: AppColors.PRIMARY_COLOR,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ))
            ],
          ),
           SizedBox(height: 10.h),
          Text(
            'participation  with wallet balance (pounds)',
            textAlign: TextAlign.center,
            style: Styles.mediumText(),
          ),
           SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding:  EdgeInsets.symmetric(
                      horizontal: 20.w, vertical: 25.h,
                    ),
                    backgroundColor: AppColors.PRIMARY_COLOR,
                  ),
                  child: Icon(
                    Icons.remove,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  )),
              const Spacer(),
              Container(
                width: context.screenWidth / 2,
                padding:
                     EdgeInsets.only(top: 3.h, bottom: 3.h, left: 2.w, right: 25.w),
                decoration: BoxDecoration(
                  color: AppColors.PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {},
                    ),
                    const Spacer(),
                    Text('0',
                        style: Styles.mediumText(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          fontSize: 100.sp,
                        )),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding:  EdgeInsets.symmetric(
                      horizontal: 20.w, vertical: 25.h,
                    ),
                    backgroundColor: AppColors.PRIMARY_COLOR,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ))
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                       EdgeInsets.symmetric(horizontal: 40.w, vertical: 25.h),
                  backgroundColor: AppColors.SECONDARY_COLOR,
                ),
                child: Text('Subscribe to the product',
                    style: Styles.mediumText(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        fontSize: 50.sp)),
              ),
              const Spacer(),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding:  EdgeInsets.symmetric(
                        horizontal: 20.w, vertical: 25.h),
                    backgroundColor: AppColors.SECONDARY_COLOR,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
