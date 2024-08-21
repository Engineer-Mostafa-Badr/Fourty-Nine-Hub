import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        appBar: const BackAppBar(
          label: 'Settings',
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
                        // activeColor: Colors.blue,
                        // activeTrackColor: Colors.grey,
                        value: isGranted,
                        onChanged: (v) async =>
                            await Permission.notification.request());
                  }),
              label: 'Enable Notifications',
              onTap: () async => await Permission.notification.request(),
            ),
            BlocBuilder<ThemeCubit, ThemeStates>(
              builder: (BuildContext context, theme) {
                return SwitchListTile(
                  secondary: Icon(
                    theme is DarkThemeModeStates
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                    size: 28,
                  ),
                  title: theme is DarkThemeModeStates
                      ?  Text(
                          'light mode',
                          style: Styles.
                          headerText(color: AppColors.AUTH_CONTAINER_COLOR,fontWeight: FontWeight.w400),
                        )
                      :  Text(
                          'dark mode',
                          style:Styles.
                              headerText(color: AppColors.QUANTITY_COLOR,fontWeight: FontWeight.w400),
                        ),
                  value: ThemeCubit.get(context).isDarkTheme,
                  activeColor: Colors.grey,
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
                trailing: const Icon(Icons.arrow_forward_ios_outlined),
                label: 'Change Password',
                onTap: () => context.push(Routes.FORGOTPASSWORD)),
            listTileWidget(
                icon: Icons.no_accounts,
                trailing: const Icon(Icons.arrow_forward_ios_outlined),
                label: 'Disable Account',
                onTap: () => showAreYouSure(
                    title: 'Alert!',
                    subTitle: 'Are you sure you want to disable your account?',
                    action: () => context.go(Routes.LOGIN),
                    context: context)),
            listTileWidget(
                icon: Icons.account_circle_outlined,
                trailing: const Icon(Icons.arrow_forward_ios_outlined),
                label: 'Delete Account',
                onTap: () => showAreYouSure(
                    title: 'Alert!',
                    subTitle: 'Are you sure you want to delete your account?',
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
        size: 25,
      ),
      title: Label(text: label,style: Styles.headerText(fontWeight: FontWeight.w400),),
      onTap: () => onTap(),
      trailing: trailing,
    );
  }
}
