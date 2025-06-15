import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/localization/locales.dart';
import '../../../../core/widget/custom_switch_list_title.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../../../functions/helper/lang_helper.dart';
import '../../../theme/cubit/cubit.dart';
import '../../../theme/cubit/states.dart';
import '../../dynamic/sizer.dart';
import '../buttons/default_button.dart';
import '../labels/label.dart';

class ChooseLangScreen extends StatefulWidget {
  const ChooseLangScreen({super.key});

  @override
  State<ChooseLangScreen> createState() => _ChooseLangScreenState();
}

class _ChooseLangScreenState extends State<ChooseLangScreen> {
  bool isChooseLang = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ThemeCubit, ThemeStates>(
          builder: (BuildContext context, theme) {
        var themeCubit = context.read<ThemeCubit>();
        return SafeArea(
          child: Center(
            child: Column(
              children: [
                const Spacer(),
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    themeCubit.isDarkTheme
                        ? Assets.logo
                        : Assets.logoWithBlackText,
                  ),
                ),
                const Spacer(),
                if (!isChooseLang)
                  Expanded(
                    flex: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.asset(
                        Assets.langGIF,
                        fit: BoxFit.fitHeight,
                        // width: double.infinity,
                        height: 500,
                      ),
                    ),
                  )
                else
                  Expanded(
                    flex: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.asset(
                        Assets.themeModeGIF,
                        height: 500,
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                const Spacer(),
                if (!isChooseLang)
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          spacing: 16,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Label(
                                text: 'اختيار اللغه',
                                style: Styles.mediumText(),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * .4,
                              height: 60.h,
                              child: DefaultButton(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                width: double.infinity,
                                label: 'عربي',
                                labelStyle: TextStyle(
                                    fontSize: 32.sp,
                                    color: AppColors.AUTH_CONTAINER_COLOR),
                                onPressed: () {
                                  changeLang(
                                      locale: Locales.arabic, context: context);
                                  Future.delayed(const Duration(seconds: 1));
                                  setState(() {
                                    isChooseLang = true;
                                  });
                                  // context.go(Routes.onBoardingScreen);
                                },
                              ),
                            ),
                          ],
                        ),
                        const Sizer(
                          height: 24,
                        ),
                        Column(
                          spacing: 16,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Label(
                                text: 'Choose Language',
                                style: Styles.mediumText(),
                              ),
                            ),
                            SizedBox(
                              height: 60.h,
                              width: MediaQuery.sizeOf(context).width * .4,
                              child: DefaultButton(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                width: double.infinity,
                                label: 'English',
                                labelStyle: TextStyle(
                                    fontSize: 32.sp,
                                    color: AppColors.AUTH_CONTAINER_COLOR),
                                onPressed: () {
                                  changeLang(
                                      locale: Locales.english,
                                      context: context);
                                  Future.delayed(const Duration(seconds: 1));
                                  setState(() {
                                    isChooseLang = true;
                                  });
                                  // context.go(Routes.onBoardingScreen);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: CustomSwitchListTile(
                      secondary: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 44.w,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            Assets.themeMode,
                            width: 50.h,
                            height: 50.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: themeCubit.isDarkTheme
                          ? Label(
                              text: LocaleKeys.lightMode.localize,
                              style: Styles.mediumText(
                                // fontSize: 35.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            )
                          : Label(
                              text: LocaleKeys.darkMode.localize,
                              style: Styles.mediumText(
                                fontSize: 65.sp,
                                fontWeight: FontWeight.w400,
                                color: themeCubit.isDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                      value: themeCubit.isDarkTheme,
                      onChanged: (value) {
                        if (theme is LightThemeModeStates) {
                          ThemeCubit.get(context).darkThemeMode();
                        }
                        if (theme is DarkThemeModeStates) {
                          ThemeCubit.get(context).lightThemeMode();
                        }
                      },
                    ),
                  ),
                const Spacer(),
                if (isChooseLang)
                  SizedBox(
                    height: 60.h,
                    width: MediaQuery.sizeOf(context).width * .9,
                    child: DefaultButton(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8),
                      label: LocaleKeys.next.localize,
                      labelStyle: TextStyle(
                          fontSize: 35.sp,
                          color: AppColors.AUTH_CONTAINER_COLOR),
                      width: double.infinity,
                      onPressed: () {
                        context.go(Routes.onBoardingScreen);
                      },
                    ),
                  ),
                const Spacer(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
