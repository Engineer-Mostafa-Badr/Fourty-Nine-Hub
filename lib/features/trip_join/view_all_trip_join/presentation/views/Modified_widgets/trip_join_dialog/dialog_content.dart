import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DialogContent extends StatelessWidget {
  const DialogContent({
    super.key,
    required this.subTitle,
    required this.rightButtonTitle,
    required this.leftButtonTitle,
  });

  final String subTitle;
  final String rightButtonTitle;
  final String leftButtonTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h,vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.alert.localize,
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.SECONDARY_COLOR,
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
                  onPressed: (){ Navigator.of(context).pop();},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
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
                    style: Styles.headerText(),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: (){ Navigator.of(context).pop();},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonDialog,
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
                    style: Styles.headerText(),
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
