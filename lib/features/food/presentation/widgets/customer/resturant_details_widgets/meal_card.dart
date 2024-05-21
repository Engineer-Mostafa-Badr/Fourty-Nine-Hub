import 'package:flutter/material.dart';

import '../../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/const.dart';
import '../../../../../../res/style/styles.dart';

class MealCard extends StatelessWidget {
  const MealCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kToolbarHeight * 2.5,
      height: kToolbarHeight * 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: SquareImage(
                radius: 5, source: NetworkImage(UIConst.restaurantPlaceHolder)),
          ),
          Label(
            text: 'Quadro Broast',
            style: Styles.mediumText(fontWeight: FontWeight.w400),
          ),
          Label(
              text: '240 EGP',
              style: Styles.mediumText(
                color: AppColors.SECONDARY_COLOR,
              )),
          Label(
              text: '384 EGP OG',
              style: Styles.mediumText(decoration: TextDecoration.lineThrough))
        ],
      ),
    );
  }
}
