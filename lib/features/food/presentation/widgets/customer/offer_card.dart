import 'package:flutter/material.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/const.dart';
import '../../../../../res/style/styles.dart';

class FoodOfferCard extends StatelessWidget {
  const FoodOfferCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight * 2,
      width: kToolbarHeight * 1.5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.SECONDARY_COLOR.withAlpha(100)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SquareImage(source: NetworkImage(UIConst.burgerPNG)),
          const Sizer(),
          Label(
              textAlign: TextAlign.center,
              text: 'Menue Discount',
              style: Styles.mediumText())
        ],
      ),
    );
  }
}
