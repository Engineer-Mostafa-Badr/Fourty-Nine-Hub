import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../res/style/app_colors.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BackAppBar(label: 'Settings',),
        body: Column(
          children: [
            listTileWidget(
                icon: Icons.notifications_active_outlined,
                trailing: Switch(value: true, onChanged: (v) {}),
                label: 'Enable Notifications',
                onTap: () {}),
            listTileWidget(
                icon: Icons.password,
                trailing: const Icon(Icons.arrow_forward_ios_outlined),
                label: 'Change Password',
                onTap: () {}),
            listTileWidget(
                icon: Icons.no_accounts,
                trailing: const Icon(Icons.arrow_forward_ios_outlined),
                label: 'Disable Account',
                onTap: () {}),
            listTileWidget(
                icon: Icons.account_circle_outlined,
                trailing: const Icon(Icons.arrow_forward_ios_outlined),
                label: 'Delete Account',
                onTap: () => bottomSheet(context: context, widget: Column())),
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
        color: AppColors.PRIMARY_COLOR,
      ),
      title: Label(text: label),
      onTap: () => onTap(),
      trailing: trailing,
    );
  }
}
