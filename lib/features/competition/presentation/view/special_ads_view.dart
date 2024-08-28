import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/competition/presentation/pages/winners.dart';
import 'package:fourtyninehub/features/competition/presentation/view/widgets/special_ads_body.dart';

import '../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../res/strings/labels.dart';

class SpecialAdsView extends StatelessWidget {
  const SpecialAdsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        centerTitle: false,
        label: Labels.competitions,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Winners()),
              );
            },
            child: const Text(
              'Winners 🏆',
              style: TextStyle(fontSize: 17, color: Colors.red),
            ),
          ),
        ],
      ),
      body: const SpecialAdsBody(),
    );
  }
}
