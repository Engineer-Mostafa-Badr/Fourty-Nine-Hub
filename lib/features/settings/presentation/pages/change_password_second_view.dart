import 'package:flutter/material.dart';
import '../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/widget/custom_scaffold.dart';
import 'widgets/change_password_second_view_body.dart';

class ChangePasswordSecondView extends StatelessWidget {
  const ChangePasswordSecondView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      enableCustomAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: LocaleKeys.changePassword.localize,
          enableCustomAppBar: true,
        ),
      ),
      body: const ChangePasswordSecondViewBody(),
    );
  }
}
