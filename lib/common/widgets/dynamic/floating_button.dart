import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../../res/assets/assets.dart';
import '../../../res/style/app_colors.dart';
import '../../../routes/routes.dart';

class FloatingButton extends StatelessWidget {
  final int changeView;

  final IconData? icon;
  final Function? onTap;
  const FloatingButton({super.key, this.changeView = 0, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap != null
          ? () => onTap!()
          : () {
              if (changeView == 1) {
                context.push(Routes.SOCIAL);
              } else if (changeView == 2) {
                context.push(Routes.YOUTUBE);
              } else {
                context.push(Routes.HOME);
              }
            },
      backgroundColor: changeView == 2 ? AppColors.PRIMARY_COLOR : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(200),
      ),
      child: icon != null
          ? Icon(
              icon,
              color: AppColors.SECONDARY_COLOR,
            )
          : Image.asset(
              Assets.logo,
              height: 30,
            ),
      //params
    );
  }
}
