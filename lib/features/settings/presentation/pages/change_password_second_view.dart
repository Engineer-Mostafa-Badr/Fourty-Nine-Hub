import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/settings/presentation/pages/widgets/change_password_second_view_body.dart';

class ChangePasswordSecondView extends StatelessWidget {
  const ChangePasswordSecondView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      enableCustomAppBar: true,
      appBar: BackAppBar(
        label: LocaleKeys.changePassword.localize,
        enableCustomAppBar: true,
      ),
      body: const ChangePasswordSecondViewBody(),
    );
  }
}
