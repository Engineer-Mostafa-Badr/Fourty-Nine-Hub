import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/competition/presentation/pages/winners.dart';
import 'package:fourtyninehub/features/competition/presentation/view/widgets/special_ads_body.dart';

import '../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../core/widget/custom_scaffold.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class SpecialAdsView extends StatelessWidget {
  const SpecialAdsView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          centerTitle: false,
          label: LocaleKeys.competition.localize,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Winners()),
                );
              },
              child: Text(
                '${LocaleKeys.winners.localize} 🏆',
                style: Styles.mediumText(color: AppColors.SECONDARY_COLOR),
              ),
            ),
          ],
        ),
      ),
      body: const SpecialAdsBody(),
    );
  }
}
