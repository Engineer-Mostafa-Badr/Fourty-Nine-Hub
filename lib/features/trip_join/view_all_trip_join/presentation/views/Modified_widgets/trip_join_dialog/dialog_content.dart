import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/extensions/context_extension.dart';
import '../../../../../../../core/extensions/string_extension.dart';
import '../../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../../res/style/app_colors.dart';
import '../../../../../../../res/style/styles.dart';
import '../../../../../../../helpers/manage_vibration.dart';

class DialogContent extends StatelessWidget {
  const DialogContent({
    super.key,
    this.onRightButtonPressed,
    required this.subTitle,
    required this.rightButtonTitle,
    required this.leftButtonTitle,
  });

  final String subTitle;
  final String rightButtonTitle;
  final String leftButtonTitle;
  final VoidCallback? onRightButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h,vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.alert.localize,
            style:  TextStyle(
              fontSize: 18,
              color:context.isDarkMode?AppColors.red_Color_DARK: AppColors.SECONDARY_COLOR,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: context.isDarkMode ? Colors.white : Colors.black,
              // fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: (){
      ManageVibration.vibrate();
                     Navigator.of(context).pop();
                     },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:context.isDarkMode?AppColors.red_Color_DARK:  AppColors.SECONDARY_COLOR,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.h,
                      vertical: 12.h,
                    ),
                  ),
                  child: Text(
                    leftButtonTitle,
                    style: Styles.headerText(color:context.isDarkMode?Colors.black:Colors.white ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: (){
      ManageVibration.vibrate();
      onRightButtonPressed?? Navigator.of(context).pop();
                     },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:context.isDarkMode?AppColors.Floating_Button_COLOR_DARK: AppColors.buttonDialog,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.h,
                      vertical: 12.h,
                    ),
                  ),
                  child: Text(
                    rightButtonTitle,
                    style: Styles.headerText(color:context.isDarkMode?Colors.black:Colors.white ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}