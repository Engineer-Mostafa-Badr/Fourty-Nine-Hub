import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/styles.dart';

class FollowButtonInstagram extends StatelessWidget {
  const FollowButtonInstagram({
    super.key,
    required this.isReel,
    required this.isFollow,
    required this.onPressed,
  });

  final bool isReel;
  final bool isFollow;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label:isFollow? LocaleKeys.unfollow.localize : LocaleKeys.follow.localize,
      style: Styles.mediumText(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        height: 1.25,
        color: isReel ? Colors.white : Colors.black,
      ),
      width: 160.w,
      height: 50.h,
      backColor:
          context.isDarkMode ? const Color(0xff868686) : Colors.transparent,
      radius: 4,
      border: Border.all(
          color: isReel
              ? (context.isDarkMode ? Colors.transparent : Colors.white)
              : Colors.black),
      onPressed: onPressed,
    );
  }
}
