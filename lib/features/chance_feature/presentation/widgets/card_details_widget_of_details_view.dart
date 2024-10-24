import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class CardDetails extends StatelessWidget {
  const CardDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow:AppColors.SHADOW_LIGHT,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 250.h,
              width: 250.w,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Image.asset(
                'assets/images/doctor.png',
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 20,),
             Text(
              LocaleKeys.SubscriberCompletionRate.localize,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 30.h),
            Container(
              height: 20.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: 0.65,
                  color: AppColors.SECONDARY_COLOR,
                  backgroundColor: Colors.grey.shade300,
                ),
              ),
            ),
            SizedBox(height: 30.h),
             Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.ProductDescription.localize,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'This product is the Honor 90 Lite Dual SIM phone that comes with FHD screen, high resolution rear camera and powerful processor.',
                  style: Styles.mediumText(

                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
