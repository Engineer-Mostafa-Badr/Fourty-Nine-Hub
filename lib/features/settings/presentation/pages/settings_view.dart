import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:fourtyninehub/features/settings/presentation/cubit/settings_state.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/theme/cubit/cubit.dart';
import '../../../../common/theme/cubit/states.dart';
import '../../../../core/messages/messages.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';

import '../../../../res/style/styles.dart';
import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<UserCubit>();
    return Scaffold(
        appBar: BackAppBar(
          label: LocaleKeys.settings.localize,
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
                children: [
                  if (context.read<UserCubit>().isLoggedIn)
                    listTileWidget(
                        image: Assets.password,
                        trailing:
                            Icon(Icons.arrow_forward_ios_outlined, size: 40.h),
                        label: LocaleKeys.changePassword.localize,
                        onTap: () => context.push(Routes.FORGOTPASSWORD)),
                  if (context.read<UserCubit>().isLoggedIn)
                    listTileWidget(
                        image: Assets.noPerson,
                        trailing:
                            Icon(Icons.arrow_forward_ios_outlined, size: 40.h),
                        label: LocaleKeys.disableAccount.localize,
                        onTap: () => showAreYouSure(
                            title: LocaleKeys.alert.localize,
                            subTitle: LocaleKeys.disable.localize,
                            action: () {
                              //  if (state.able?.isDisabled == false) {
                              return context
                                  .read<SettingCubit>()
                                  .disableAccount();
                              // } else {
                              //   return context.read<SettingCubit>().enableAccount();
                              // }
                            },
                            context: context)),
                  if (context.read<UserCubit>().isLoggedIn)
                    listTileWidget(
                        image: Assets.person,
                        trailing: Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 40.h,
                        ),
                        label: LocaleKeys.deleteAccount.localize,
                        onTap: () => showAreYouSure(
                            title: LocaleKeys.alert.localize,
                            subTitle: LocaleKeys.delete.localize,
                            action: () {
                              context.read<SettingCubit>().deleteAccount();
                            },
                            context: context)),
                  BlocBuilder<ThemeCubit, ThemeStates>(
                    builder: (BuildContext context, theme) {
                      return SwitchListTile(
                        secondary: Image.asset(
                          Assets.theme,
                          width: 50.h,
                          height: 50.h,
                          fit: BoxFit.cover,
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
                        activeColor: AppColors.SECONDARY_COLOR,
                        activeTrackColor: AppColors.AUTH_CONTAINER_COLOR,
                        inactiveTrackColor: AppColors.AUTH_CONTAINER_COLOR,
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
      leading: Image.asset(
        image,
        width: 50.h,
        height: 50.h,
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
