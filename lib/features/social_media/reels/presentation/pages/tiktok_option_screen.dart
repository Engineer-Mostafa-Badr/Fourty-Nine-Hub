import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';

import '../widgets/tiktok_option_body.dart';

class TiktokOptionScreen extends StatelessWidget {
  const TiktokOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: context.isDarkMode ? Colors.black : Colors.white,
      body: TiktokOptionBody(),
    );
  }
}
