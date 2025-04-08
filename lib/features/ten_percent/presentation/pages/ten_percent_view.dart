import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ten_percent/presentation/pages/widget/ten_percent_view_body.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widget/custom_scaffold.dart';
import '../../../../routes/routes.dart';
import '../../../account_taps/wallet/presentation/widgets/custom_winner_appbar.dart';

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
                context.push(Routes.WINNERSGift);
              },
            ),
          ],
        ),
      ),
      body: const TenPercentViewBody(),
    );
  }
}
