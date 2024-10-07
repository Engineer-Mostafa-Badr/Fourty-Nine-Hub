import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import '../widgets/chance_details_body.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

class ChanceDetailsView extends StatelessWidget {
  const ChanceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: BackAppBar(
        label: LocaleKeys.ChanceDetails.localize,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ChanceDetailsBody(),
      ),
    );
  }
}

