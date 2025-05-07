import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class FindDialogContent extends StatelessWidget {
  const FindDialogContent({
    super.key,
    required this.topButtonTitle,
    required this.bottomButtonTitle,
  });

  final String topButtonTitle;
  final String bottomButtonTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
              child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close,color: AppColors.getTextColor(context),))),
          const Sizer(),
          Label(
              text:context.isArabic?'حظر Mohamed Magdy ؟': 'Block Mohamed Magdy?',
              style: Styles.headerText(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.getTextColor(context),
              )),
          FractionallySizedBox(
            widthFactor:0.7 ,
            child: Label(
              text:
              context.isArabic?'لن تستطيع العودة عن ذلك. هل تريد الاستمرار؟':'You won’t be able to undo this. Are you sure you want to continue?',
              maxLines: 3,
              textAlign: TextAlign.center,
              style: Styles.mediumText(
                color: AppColors.getTextColor(context),
              ),
            ),
          ),
          const Sizer(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.getRedColor(context),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 20.h,
                vertical: 12.h,
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                topButtonTitle,
                style: Styles.headerText(fontSize: 32,color:  context.isDarkMode?Colors.black:Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const Sizer(
            height: 20,
          ),
          ClickableWidget(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Text(
              bottomButtonTitle,
              style: Styles.headerText(
                fontSize: 32,
                color: AppColors.getTextColor(context),
              ),
            ),
          ),
          const Sizer(),
        ],
      ),
    );
  }
}
