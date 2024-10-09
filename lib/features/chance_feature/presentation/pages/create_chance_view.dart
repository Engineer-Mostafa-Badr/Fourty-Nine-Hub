import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

import '../widgets/create_chance_view_body.dart';


class CreateChanceView extends StatelessWidget {
  const CreateChanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: BackAppBar(
        label: LocaleKeys.CreateChance.localize,
      ),
      body:  CreateChanceViewBody(),
    );
  }
}
