import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/handle_cashback.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/Social_home.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/shared_pref.dart';
import '../../../features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import '../../../res/assets/assets.dart';
import '../../../res/style/app_colors.dart';
import '../../../res/style/styles.dart';
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
            : () async {
                HandleCashback.setCount('socialCount', context);
                if (changeView == 1) {
                  context.read<CreatePostCubit>().loadData();
                  context.go(
                    Routes.SOCIAL,
                    extra: SocialParams(
                      userId: UserCubit.to.state.data?.id ?? '',
                      index: 0,
                    ),
                  );
                } else {
                  bool isCustomPage =
                      await CacheManager.getActivation() ?? false;
                  if (isCustomPage) {
                    context.go(
                      Routes.PAGEPREVIEW,
                    );
                  } else {
                    context.push(Routes.HOME);
                  }
                }
              },
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: icon != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.floatImage,
                    color: context.isDarkMode
                        ? Colors.white
                        : AppColors.PRIMARY_COLOR,
                    height: 50.h,
                    width: 50.w,
                  ),
                  Label(
                    text: LocaleKeys.social.localize,
                    style: Styles.smallText(
                      color: context.isDarkMode
                          ? Colors.white
                          : AppColors.PRIMARY_COLOR,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.logoWithoutText,
                    height: 50.h,
                    width: 50.w,
                  ),
                  Label(
                    text: LocaleKeys.home.localize,
                    style: Styles.smallText(
                      color: context.isDarkMode
                          ? Colors.white
                          : AppColors.PRIMARY_COLOR,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
