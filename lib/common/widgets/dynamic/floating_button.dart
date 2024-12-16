import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/utils/handle_cashback.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/Social_home.dart';
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
      height: 90.h, // Set the desired height
      width: 90.h,
      child: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: onTap != null
            ? () => onTap!()
            : () {
          HandleCashback.setCount('socialCount',context);

                if (changeView == 1) {
                  context.push(Routes.SOCIAL,extra: SocialParams(userId: UserCubit.to.state.data?.id??'',index: 0));
                } else {
                  context.push(Routes.HOME);
                }
              },
        backgroundColor: Colors.white,
        child: icon != null
            ? Icon(
                icon,
                color: AppColors.PRIMARY_COLOR,
          size: 50.sp,
              )
            : Image.asset(
                Assets.logo,
                height: 50.h,
                width: 50.w,
              ),
      ),
    );
  }
}
