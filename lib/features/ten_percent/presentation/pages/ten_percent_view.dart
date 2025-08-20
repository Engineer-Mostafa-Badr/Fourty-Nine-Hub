import 'package:flutter/material.dart';
import '../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import 'widget/ten_percent_view_body.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widget/custom_scaffold.dart';
import '../../../../routes/routes.dart';
import '../../../account_taps/wallet/presentation/widgets/custom_winner_appbar.dart';
import '../../../../helpers/manage_vibration.dart';

class TenPercentView extends StatelessWidget {
  const TenPercentView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: LocaleKeys.billCashback.localize,
          actions: [
            CustomWinnerAppbar(
              onPressed: () {
      ManageVibration.vibrate();
                context.push(Routes.WinnersTenPercent);
              },
            ),
          ],
        ),
      ),
      body: const TenPercentViewBody(),
    );
  }
}