import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/extensions/context_extension.dart';
import '../../../../../../../core/extensions/string_extension.dart';
import '../../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../../res/style/app_colors.dart';
import '../../../../../../../res/style/styles.dart';

import '../../../../../../../helpers/manage_vibration.dart';

class PremiumAndRequestWidget extends StatelessWidget {
  const PremiumAndRequestWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.getRedColor(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {
              ManageVibration.vibrate();
            },
            child: Center(
              child: Text(context.isArabic ? 'نشر مميز' : 'Premium Publish',
                  style: Styles.headerText(
                      color: context.isDarkMode ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30)),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.getButtonPrimaryColor(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {
              ManageVibration.vibrate();
            },
            child: Center(
              child: Text(
                LocaleKeys.publish.localize,
                style: Styles.headerText(
                    color: context.isDarkMode ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PremiumAndRequestTripWidget extends StatelessWidget {
  final VoidCallback onPremiumPressed;
  final VoidCallback onNormalPressed;

  const PremiumAndRequestTripWidget({
    super.key,
    required this.onPremiumPressed,
    required this.onNormalPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.getRedColor(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: onPremiumPressed,
            child: Center(
              child: Text(
                context.isArabic ? 'نشر مميز' : 'Premium Publish',
                style: Styles.headerText(
                  color: context.isDarkMode ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.getButtonPrimaryColor(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: onNormalPressed,
            child: Center(
              child: Text(
                LocaleKeys.publish.localize,
                style: Styles.headerText(
                  color: context.isDarkMode ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
