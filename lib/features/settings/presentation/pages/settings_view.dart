import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/theme/cubit/cubit.dart';
import '../../../../common/theme/cubit/states.dart';
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
        body: Column(
          children: [
            listTileWidget(
              icon: Icons.notifications_active_outlined,
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
                  secondary: Icon(
                    theme is DarkThemeModeStates
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                    size: 40.zH,
                  ),
                  title: theme is DarkThemeModeStates
                      ? Text(
                          LocaleKeys.lightMode.localize,
                          style: Styles.mediumText(
                              fontSize: 32, fontWeight: FontWeight.w400),
                        )
                      : Text(
                          LocaleKeys.darkMode.localize,
                          style: Styles.mediumText(
                              fontSize: 32, fontWeight: FontWeight.w400),
                        ),
                  value: ThemeCubit.get(context).isDarkTheme,
                  activeColor: AppColors.SECONDARY_COLOR,
                  activeTrackColor: AppColors.AUTH_CONTAINER_COLOR,
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
                icon: Icons.password,
                trailing: Icon(Icons.arrow_forward_ios_outlined, size: 40.zH),
                label: LocaleKeys.changePassword.localize,
                onTap: () => context.push(Routes.FORGOTPASSWORD)),
            listTileWidget(
                icon: Icons.no_accounts,
                trailing: Icon(Icons.arrow_forward_ios_outlined, size: 40.zH),
                label: LocaleKeys.disableAccount.localize,
                onTap: () => showAreYouSure(
                    title: LocaleKeys.alert.localize,
                    subTitle: LocaleKeys.disable.localize,
                    action: () => context.go(Routes.LOGIN),
                    context: context)),
            listTileWidget(
                icon: Icons.account_circle_outlined,
                trailing: Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 40.zH,
                ),
                label: LocaleKeys.deleteAccount.localize,
                onTap: () => showAreYouSure(
                    title: LocaleKeys.alert.localize,
                    subTitle: LocaleKeys.delete.localize,
                    action: () => context.go(Routes.LOGIN),
                    context: context)),
          ],
        ));
  }

  Widget listTileWidget(
      {required IconData icon,
      required Widget trailing,
      required String label,
      required Function onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        size: 40.zH,
      ),
      title: Label(
          text: label,
          style: Styles.mediumText(fontSize: 32, fontWeight: FontWeight.w400)),
      onTap: () => onTap(),
      trailing: trailing,
    );
  }
}
