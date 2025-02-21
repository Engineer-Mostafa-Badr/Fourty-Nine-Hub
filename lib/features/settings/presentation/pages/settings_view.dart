import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/settings/presentation/cubit/floating_navigator_cubit.dart';
import 'package:fourtyninehub/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:fourtyninehub/features/settings/presentation/cubit/settings_state.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/theme/cubit/cubit.dart';
import '../../../../common/theme/cubit/states.dart';
import '../../../../core/messages/messages.dart';
import '../../../../core/widget/custom_scaffold.dart';
import '../../../../core/widget/custom_switch_list_title.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';

import '../../../../res/style/styles.dart';
import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<UserCubit>();
    return CustomScaffold(
        enableCustomAppBar: true,
        appBar: BackAppBar(
          label: LocaleKeys.settings.localize,
          enableCustomAppBar: true,
        ),
        body: BlocProvider<SettingCubit>(
          create: (BuildContext context) => serviceLocator(),
          child: BlocConsumer<SettingCubit, SettingState>(
            listener: (BuildContext context, SettingState state) {
              if (state.status == SettingStates.success1) {
                showSuccessMessage(
                  context,
                  LocaleKeys.deleteSuccessfully.localize,
                );
                controller.logout(context);
                context.push(Routes.HOME);
              }
              if (state.status == SettingStates.success1) {
                showSuccessMessage(
                  context,
                  LocaleKeys.disableAccount.localize,
                );
                controller.logout(context);
                context.push(Routes.HOME);
              }
            },
            builder: (BuildContext context, state) {
              print('Account isDisabled status: ${state.able?.isDisabled}');
              return Column(
                spacing: 32,
                children: [
                  Container(),
                  if (context.read<UserCubit>().isLoggedIn)
                    listTileWidget(
                        image: Assets.editProfile,
                        trailing:
                            Icon(Icons.arrow_forward_ios_outlined, size: 40.h),
                        label: LocaleKeys.editProfile.localize,
                        onTap: () => context.push(Routes.EDITPROFILE)),
                  if (context.read<UserCubit>().isLoggedIn)
                    listTileWidget(
                        image: Assets.changePassword,
                        trailing:
                            Icon(Icons.arrow_forward_ios_outlined, size: 40.h),
                        label: LocaleKeys.changePassword.localize,
                        onTap: () => context.push(Routes.FORGOTPASSWORD)),
                  if (context.read<UserCubit>().isLoggedIn)
                    listTileWidget(
                        image: Assets.disableAccount,
                        trailing:
                            Icon(Icons.arrow_forward_ios_outlined, size: 40.h),
                        label: LocaleKeys.disableAccount.localize,
                        onTap: () => showAreYouSure(
                            title: LocaleKeys.alert.localize,
                            subTitle: LocaleKeys.disable.localize,
                            action: () async{
                               if (state.able?.isDisabled == false) {
                                 final prefs = await SharedPreferences.getInstance();
                                 await prefs.setBool("ISLOGIN", false);
                                 context.go(Routes.HOME);
                              return context
                                  .read<SettingCubit>()
                                  .disableAccount();
                              } else {
                                return context.read<SettingCubit>().enableAccount();
                              }
                            },
                            context: context)),
                  if (context.read<UserCubit>().isLoggedIn)
                    listTileWidget(
                        image: Assets.deleteAccount,
                        trailing: Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 40.h,
                        ),
                        label: LocaleKeys.deleteAccount.localize,
                        onTap: () => showAreYouSure(
                            title: LocaleKeys.alert.localize,
                            subTitle: LocaleKeys.delete.localize,
                            action: () async{
                              context.read<SettingCubit>().deleteAccount();
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setBool("ISLOGIN", false);
                              context.go(Routes.HOME);
                            },
                            context: context)),
                  BlocBuilder<ThemeCubit, ThemeStates>(
                    builder: (BuildContext context, theme) {
                      return CustomSwitchListTile(
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
                        title: theme is DarkThemeModeStates
                            ? Text(
                                LocaleKeys.lightMode.localize,
                                style: Styles.mediumText(
                                    fontSize: 65.sp,
                                    fontWeight: FontWeight.w400),
                              )
                            : Text(
                                LocaleKeys.darkMode.localize,
                                style: Styles.mediumText(
                                    fontSize: 65.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                        value: ThemeCubit.get(context).isDarkTheme,
                        onChanged: (value) {
                          if (theme is LightThemeModeStates) {
                            ThemeCubit.get(context).darkThemeMode();
                          }
                          if (theme is DarkThemeModeStates) {
                            ThemeCubit.get(context).lightThemeMode();
                          }
                        },
                      );
                    },
                  ),
                  BlocBuilder<FloatingNavigatorCubit, FloatingNavigatorState>(
                    builder: (context, state) {
                      var floatingNavigatorCubit =
                          FloatingNavigatorCubit.get(context);
                      return CustomSwitchListTile(
                        secondary: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 44.w,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              Assets.floatingNavigator,
                              width: 50.h,
                              height: 50.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          LocaleKeys.floatingNavigator.localize,
                          style: Styles.mediumText(
                              fontSize: 65.sp, fontWeight: FontWeight.w400),
                        ),
                        value: floatingNavigatorCubit.floatingNavigatorStatus,
                        onChanged: (value) async {
                          if (floatingNavigatorCubit.state
                              is ActiveFloatNavigatorStatusState) {
                            floatingNavigatorCubit.unActiveFloatingNavigator();
                          }
                          if (floatingNavigatorCubit.state
                              is UnActiveFloatNavigatorStatusState) {
                            floatingNavigatorCubit.activeFloatingNavigator();
                          }
                        },
                      );
                    },
                  )
                ],
              );
            },
          ),
        ));
  }

  Widget listTileWidget(
      {required String image,
      required Widget trailing,
      required String label,
      required Function onTap}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 44.w,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            image,
            width: 50.h,
            height: 50.h,
          ),
        ),
      ),
      title: Label(
          text: label,
          style:
              Styles.mediumText(fontSize: 65.sp, fontWeight: FontWeight.w400)),
      onTap: () => onTap(),
      trailing: trailing,
    );
  }
}
