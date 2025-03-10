import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/cash_back_view_body.dart';

class CashbackView extends StatelessWidget {
  const CashbackView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: BackAppBar(
        label: LocaleKeys.balance.localize,
      ),
      body: const CashbackViewBody(),
    );
  }
}
