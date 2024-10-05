import 'package:flutter/material.dart';

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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Just pay at least 1 EGP wait! If you need to pay something!!!\nOne user at least will win every month!!!!',
                textAlign: TextAlign.center,
                style: Styles.headerText().copyWith(
                  color: AppColors.PRIMARY_COLOR_DARK,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
