import 'package:flutter/material.dart';
import '../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/widget/custom_scaffold.dart';
import 'widgets/change_password_view_body.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      enableCustomAppBar: true,
      appBar: BackAppBar(
        label: LocaleKeys.changePassword.localize,
      ),
      body: const ChangePasswordViewBody(),
    );
  }
}
