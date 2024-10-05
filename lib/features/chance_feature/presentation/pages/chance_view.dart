import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/chance_view_body.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class ChanceView extends StatelessWidget {
  const ChanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chance",
          style: Styles.headerText().copyWith(
            color: AppColors.PRIMARY_COLOR_DARK,
          ),
        ),
        centerTitle: true,
      ),
      body: const ChanceViewBody(),
    );
  }
}
