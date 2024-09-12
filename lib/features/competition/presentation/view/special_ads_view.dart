import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/competition/presentation/pages/winners.dart';
import 'package:fourtyninehub/features/competition/presentation/view/widgets/special_ads_body.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../res/strings/labels.dart';

class SpecialAdsView extends StatelessWidget {
  const SpecialAdsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
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
              style:  TextStyle(fontSize: 17.sp, color: Colors.red),
            ),
          ),
        ],
      ),
      body: const SpecialAdsBody(),
    );
  }
}
