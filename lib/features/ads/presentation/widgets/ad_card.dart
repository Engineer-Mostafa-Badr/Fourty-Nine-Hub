import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/const.dart';
import '../../../../res/style/styles.dart';

class AdCard extends StatelessWidget {
  const AdCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                const Positioned.fill(
                  child: SquareImage(
                      radius: 10,
                      source: NetworkImage(UIConst.restaurantPlaceHolder)),
                ),
                Positioned(
                    top: 5,
                    right: 5,
                    bottom: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconAppButton(
                            size: 20,
                            backColor: Colors.white,
                            icon: Icons.favorite_border,
                            isCircle: true,
                            color: Colors.red,
                            onPressed: () {}),
                        IconAppButton(
                            size: 20,
                            color: Colors.white,
                            icon: Icons.call,
                            isCircle: true,
                            backColor: AppColors.GRAY_LIGHT_COLOR3,
                            onPressed: () {}),
                        IconAppButton(
                            size: 20,
                            color: Colors.white,
                            icon: Icons.chat,
                            isCircle: true,
                            backColor: AppColors.GRAY_LIGHT_COLOR3,
                            onPressed: () {}),
                      ],
                    ))
              ],
            ),
          )),
          Label(
            text: 'Ad Title',
            style: Styles.mediumText(fontWeight: FontWeight.bold),
          ),
          Label(
            text: 'Ad Subtitle',
            style: Styles.mediumText(),
          ),
          AppButton(
              label: 'Request',
              padding: 10,
              icon: Icons.check_circle_outline,
              onPressed: () {}),
        ],
      ),
    );
  }
}
