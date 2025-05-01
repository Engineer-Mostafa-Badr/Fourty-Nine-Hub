import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class SpotLightDialogContent extends StatelessWidget {
  const SpotLightDialogContent({
    super.key,
    required this.topButtonTitle,
    required this.bottomButtonTitle,
  });
  final String topButtonTitle;
  final String bottomButtonTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h,vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              context.isArabic ? 'مسح سجل البحث؟' : 'Clear Recents?',
            style: Styles.headerText(fontWeight: FontWeight.w500,fontSize: 40,)
          ),
          const Sizer(height: 20),
          ElevatedButton(
            onPressed: (){ Navigator.of(context).pop();},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.PRIMARY_COLOR,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
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
                style: Styles.headerText(),textAlign: TextAlign.center,
              ),
            ),
          ),
          const Sizer(height: 20,),
          ClickableWidget(
            onTap: (){ Navigator.of(context).pop();},
            child: Text(
              bottomButtonTitle,
              style: Styles.headerText(color: Colors.red,),
            ),
          ),
          const Sizer(),
        ],
      ),
    );
  }
}
