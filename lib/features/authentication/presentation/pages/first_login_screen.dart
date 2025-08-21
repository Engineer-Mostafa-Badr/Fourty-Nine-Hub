import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/theme/cubit/cubit.dart';
import '../../../../common/theme/cubit/states.dart';
import '../../../../common/widgets/stateless/buttons/default_button.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';

class FirstLoginScreen extends StatelessWidget {
  const FirstLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: AppBar(),
      ),
      body: BlocBuilder<ThemeCubit, ThemeStates>(
          builder: (BuildContext context, theme) {
        var themeCubit = context.read<ThemeCubit>();
        return SafeArea(
          child: Center(
            child: Column(
              children: [
                const Spacer(),
                Expanded(
                  flex: 5,
                  child: Image.asset(
                    themeCubit.isDarkTheme
                        ? Assets.logo
                        : Assets.logoWithBlackText,
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: themeCubit.isDarkTheme
                          ? AppColors.whiteColor
                          : AppColors.PRIMARY_COLOR,
                      width: themeCubit.isDarkTheme ? 2 : 0,
                    ),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    // margin: const EdgeInsets.symmetric(horizontal: 16),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.asset(
                      Assets.loginGIF,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Welcome to 49 HUB Super App',
                  style: TextStyle(
                    color: themeCubit.isDarkTheme
                        ? AppColors.whiteColor
                        : AppColors.PRIMARY_COLOR,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Tangerine',
                  ),
                ),
                const Text(
                  'A L L   Y O U   N E E D',
                  style: TextStyle(
                    color: AppColors.SECONDARY_COLOR,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Tangerine',
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 60.h,
                  width: MediaQuery.sizeOf(context).width * .4,
                  child: DefaultButton(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8),
                    backgroundColor: themeCubit.isDarkTheme
                        ? AppColors.whiteColor
                        : AppColors.PRIMARY_COLOR,
                    width: double.infinity,
                    label: LocaleKeys.login.localize,
                    labelStyle: TextStyle(
                        fontSize: 32.sp,
                        color: themeCubit.isDarkTheme
                            ? AppColors.PRIMARY_COLOR
                            : AppColors.AUTH_CONTAINER_COLOR),
                    onPressed: () {
                      ManageVibration.vibrate();
                      context.go(Routes.LOGIN);
                    },
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 60.h,
                  width: MediaQuery.sizeOf(context).width * .4,
                  child: DefaultButton(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8),
                    backgroundColor: themeCubit.isDarkTheme
                        ? AppColors.whiteColor
                        : AppColors.PRIMARY_COLOR,
                    width: double.infinity,
                    label: LocaleKeys.register.localize,
                    labelStyle: TextStyle(
                        fontSize: 35.sp,
                        color: themeCubit.isDarkTheme
                            ? AppColors.PRIMARY_COLOR
                            : AppColors.AUTH_CONTAINER_COLOR),
                    onPressed: () {
                      ManageVibration.vibrate();
                      context.go(Routes.REGISTER);
                    },
                  ),
                ),
                const Spacer(),
                Label(
                  text: '© 49 HUB FOR PROGRAMMING',
                  style: Styles.mediumText(
                    color: themeCubit.isDarkTheme
                        ? AppColors.whiteColor
                        : AppColors.PRIMARY_COLOR,
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                  ),
                ),
                Label(
                  text: 'V1.0.5 - All rights reserved 2025',
                  style: Styles.mediumText(
                    color: AppColors.GREY_DARK_COLOR,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                const Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
