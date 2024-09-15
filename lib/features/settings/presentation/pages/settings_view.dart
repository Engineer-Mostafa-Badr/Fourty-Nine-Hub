import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/settings/domain/entities/disable_entity.dart';
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
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../res/style/styles.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BackAppBar(
          label: LocaleKeys.settings.localize,
        ),
        body: BlocProvider<SettingCubit>(
          create: (BuildContext context) =>serviceLocator(),
          child: BlocConsumer<SettingCubit, SettingState>(
            listener: (BuildContext context, SettingState state) {
              if (state.status == SettingStates.success) {
                // showSuccessMessage(
                //   context,
                //   LocaleKeys.deleteSuccessfully.localize,
                // );
                print('77777777777777777777777777777');
                print(state.able?.isDisabled );
                print('77777777777777777777777777777');
                context.push(Routes.HOME);
              }
            },
            builder: (BuildContext context, state) {
              print('Account isDisabled status: ${state.able?.isDisabled}');
              return Column(
                children: [
                  listTileWidget(
                    image: Assets.notification,
                    trailing: FutureBuilder(
                        future: Permission.notification.isGranted,
                        builder: (context, snap) {
                          final isGranted = snap.data ?? false;
                          return Switch(
                              activeColor: AppColors.SECONDARY_COLOR,
                              activeTrackColor: Colors.grey,
                              value: isGranted,
                              onChanged: (v) async =>
                                  await Permission.notification.request());
                        }),
                    label: LocaleKeys.enableNotifications.localize,
                    onTap: () async => await Permission.notification.request(),
                  ),
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
                  listTileWidget(
                      image: Assets.password,
                      trailing:
                          Icon(Icons.arrow_forward_ios_outlined, size: 40.h),
                      label: LocaleKeys.changePassword.localize,
                      onTap: () => context.push(Routes.FORGOTPASSWORD)),
                  listTileWidget(
                      image: Assets.noPerson,
                      trailing:
                          Icon(Icons.arrow_forward_ios_outlined, size: 40.h),
                      label:state.able?.isDisabled == true? 'Enable Account':LocaleKeys.disableAccount.localize,
                      onTap: () => showAreYouSure(
                          title: LocaleKeys.alert.localize,
                          subTitle:LocaleKeys.disable.localize,
                          action: () {
                            if (state.able?.isDisabled == true) {
                              context.read<SettingCubit>().enableAccount();
                            } else {
                              context.read<SettingCubit>().disableAccount();
                            }
                          },
                          context: context)),
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
          text: label, style: Styles.mediumText(fontSize: 65.sp,fontWeight: FontWeight.w400)),
      onTap: () => onTap(),
      trailing: trailing,
    );
  }
}
