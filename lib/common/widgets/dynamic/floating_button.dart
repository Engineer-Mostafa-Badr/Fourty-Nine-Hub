import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/bottom_navigator.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:go_router/go_router.dart';

import '../../../res/assets/assets.dart';
import '../../../res/style/app_colors.dart';
import '../../../routes/routes.dart';

class FloatingButton extends StatelessWidget {
  final int changeView;
  final IconData? icon;
  final Function? onTap;

  const FloatingButton({
    super.key,
    this.changeView = 0,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.zH, // Set the desired height
      width: 90.zW,
      child: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: onTap != null
            ? () => onTap!()
            : () {
                if (changeView == 1) {
                  context.push(Routes.SOCIAL);
                } else if (changeView == 2) {
                  context.push(Routes.INSTAGRAM);
                }
              },
        backgroundColor:
            changeView == 2 ? AppColors.PRIMARY_COLOR : Colors.white,
        child: icon != null
            ? Icon(
                icon,
                color: AppColors.SECONDARY_COLOR,
              )
            : Image.asset(
                Assets.logo,
                height: 50.zH, // Adjust size as needed
                width: 50.zH, // Adjust size as needed
              ),
      ),
    );
  }
}
