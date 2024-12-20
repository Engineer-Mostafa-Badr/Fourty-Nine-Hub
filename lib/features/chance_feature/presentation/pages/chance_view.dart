import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/chance_view_body.dart';

import '../widgets/floating_action_button_widget.dart';

class ChanceView extends StatelessWidget {
  const ChanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: LocaleKeys.chance.localize,
      ),
      floatingActionButton: const FloatingActionButtonWidget(),
      body: const ChanceViewBody(),
    );
  }
}
