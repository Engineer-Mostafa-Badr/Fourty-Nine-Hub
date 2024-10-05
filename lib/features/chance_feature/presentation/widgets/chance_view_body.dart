import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/LIst_view_card.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class ChanceViewBody extends StatelessWidget {
  const ChanceViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text(
                'Just pay at least 1 EGP wait! If you need to pay something!!!\nOne user at least will win every month!!!!',
                textAlign: TextAlign.center,
                style: Styles.headerText().copyWith(
                  color: AppColors.PRIMARY_COLOR_DARK,
                ),
              ),
            ),
            const SizedBox(height: 20,),
           const ListViewCard(),
          ],
        ),
      ),
    );
  }
}
