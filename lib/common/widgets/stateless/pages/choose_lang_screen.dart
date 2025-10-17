import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
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
import 'package:flutter/services.dart';
import '../../../../core/utils/custom_show_dialog.dart';
import '../../../../core/extensions/context_extension.dart';

class ChooseLangScreen extends StatefulWidget {
  const ChooseLangScreen({super.key});

  @override
  State<ChooseLangScreen> createState() => _ChooseLangScreenState();
}

class _ChooseLangScreenState extends State<ChooseLangScreen> {
  bool isChooseLang = false;

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showAnimatedDialog(
            context,
            AlertDialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              titlePadding: const EdgeInsets.only(top: 16),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(
                LocaleKeys.warning.localize,
                style: Styles.headerText(
                    color: Colors.red, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Center(
                    child: Label(
                      text: LocaleKeys.ExitApp.localize,
                      style: Styles.headerText(
                        color: context.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Label(
                    text: LocaleKeys.sureLogoutApp.localize,
                    style: Styles.mediumText(
                      color: context.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.SECONDARY_COLOR,
                            padding: const EdgeInsets.all(0),
                            minimumSize: const Size(70, 30),
                            maximumSize: const Size(200, 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            ManageVibration.vibrate();
                            Navigator.of(context).pop(true);
                            SystemNavigator.pop();
                          },
                          child: Label(
                            text: LocaleKeys.yes.localize,
                            style: Styles.mediumText(color: Colors.white),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: context.isDarkMode
                                ? Colors.white
                                : AppColors.PRIMARY_COLOR,
                            padding: const EdgeInsets.all(0),
                            minimumSize: const Size(70, 30),
                            maximumSize: const Size(200, 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            ManageVibration.vibrate();
                            Navigator.of(context).pop(false);
                          },
                          child: Label(
                            text: LocaleKeys.no.localize,
                            style: Styles.mediumText(
                              color: context.isDarkMode
                                  ? AppColors.PRIMARY_COLOR
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          // If on theme selection step, go back to language selection
          if (isChooseLang) {
            setState(() {
              isChooseLang = false;
            });
          } else {
            // If on language selection (first step), show exit dialog
            bool shouldExit = await _showExitConfirmationDialog(context);
            if (shouldExit) {
              SystemNavigator.pop();
            }
          }
        }
      },
      child: Scaffold(
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
                                  text: 'اختيار اللغة',
                                  style: Styles.mediumText(),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * .4,
                                height: 60.h,
                                child: DefaultButton(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  backgroundColor: context.isDarkMode
                                      ? AppColors.whiteColor
                                      : AppColors.PRIMARY_COLOR,
                                  width: double.infinity,
                                  label: 'عربي',
                                  labelStyle: Styles.headerText(
                                      // fontSize: 32.sp,
                                      color: context.isDarkMode
                                          ? AppColors.PRIMARY_COLOR
                                          : AppColors.AUTH_CONTAINER_COLOR),
                                  onPressed: () {
                                    ManageVibration.vibrate();
                                    changeLang(
                                        locale: Locales.arabic,
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
                                  backgroundColor: context.isDarkMode
                                      ? AppColors.whiteColor
                                      : AppColors.PRIMARY_COLOR,
                                  width: double.infinity,
                                  label: 'English',
                                  labelStyle: Styles.headerText(
                                      // fontSize: 32.sp,
                                      color: context.isDarkMode
                                          ? AppColors.PRIMARY_COLOR
                                          : AppColors.AUTH_CONTAINER_COLOR),
                                  onPressed: () {
                                    ManageVibration.vibrate();
                                    HapticFeedback.lightImpact();
                                    HapticFeedback.vibrate();
                                    changeLang(
                                        locale: Locales.english,
                                        context: context);
                                    Future.delayed(const Duration(seconds: 1));
                                    setState(() {
                                      isChooseLang = true;
                                    });
                                    // Don't navigate here, let user click Next button
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
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        backgroundColor: context.isDarkMode
                            ? AppColors.whiteColor
                            : AppColors.PRIMARY_COLOR,
                        label: LocaleKeys.next.localize,
                        labelStyle: Styles.headerText(
                            // fontSize: 35.sp,
                            color: context.isDarkMode
                                ? AppColors.PRIMARY_COLOR
                                : AppColors.AUTH_CONTAINER_COLOR),
                        width: double.infinity,
                        onPressed: () {
                          ManageVibration.vibrate();
                          context.push(Routes.onBoardingScreen);
                        },
                      ),
                    ),
                  const Spacer(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
