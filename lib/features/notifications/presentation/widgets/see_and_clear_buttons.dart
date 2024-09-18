import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class SeeAndClearButtons extends StatelessWidget {
  const SeeAndClearButtons({
    super.key,
    required this.seeAllCallback,
    required this.clearAllCallback,
  });
  final Function seeAllCallback;
  final Function clearAllCallback;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 30.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextAppButton(
            style: const TextStyle(color: AppColors.SECONDARY_COLOR),
            label: 'See All',
            onPressed: () {
              showAreYouSure(
                title: 'See All',
                subTitle: "Do you want to mark all notifications as seen?",
                action: seeAllCallback,
                context: context,
              );
            },
          ),
          const Sizer(),
          TextAppButton(
            style: const TextStyle(color: AppColors.SECONDARY_COLOR),
            label: LocaleKeys.clearAll.localize,
            onPressed: () {
              showAreYouSure(
                title: LocaleKeys.alert.localize,
                subTitle: LocaleKeys.clearNotification.localize,
                action: clearAllCallback,
                context: context,
              );
            },
          ),
        ],
      ),
    );
  }
}
