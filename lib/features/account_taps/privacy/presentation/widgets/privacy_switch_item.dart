import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class PrivacySwitchItem extends StatelessWidget {
  final String label;
  final bool privacy;
  final Function(bool value) onPress;

  const PrivacySwitchItem({
    super.key,
    required this.label,
    required this.privacy,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Sizer(),
        Card(
          color: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                Expanded(
                    child: Label(
                  text: label,
                      style: TextStyle(fontSize: 30.sp),
                )),
                Label(
                  text: (privacy? LocaleKeys.on.localize : LocaleKeys.off.localize),
                  style: Styles.mediumText(
                    fontSize: 50.sp,
                    color: AppColors.GREY_DARK_COLOR
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Switch(
                  value: privacy,
                  onChanged: onPress,
                  activeColor: Colors.red,
                  inactiveThumbColor: Colors.black,
                  activeTrackColor: AppColors.GREY_NORMAL_COLOR,
                  inactiveTrackColor: AppColors.GREY_NORMAL_COLOR,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
