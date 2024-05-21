import 'package:flutter/material.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class PlaceBidding extends StatelessWidget {
  const PlaceBidding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: 'Bid',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              const Sizer(),
              AppButton(
                label: 'Minus',
                onPressed: () {},
                height: kToolbarHeight,
                width: kToolbarHeight,
                radius: 20,
                widget: const Icon(
                  Icons.arrow_drop_down_rounded,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Label(
                      text: 'Your bid:',
                      style: Styles.headerText(color: AppColors.PRIMARY_COLOR)),
                  Label(
                      text: '\$ 595',
                      style: Styles.headerText(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppColors.PRIMARY_COLOR)),
                  Label(
                      text: 'Highest bid: \$ 590', style: Styles.mediumText()),
                ],
              )),
              AppButton(
                label: 'Add',
                onPressed: () {},
                radius: 20,
                height: kToolbarHeight,
                width: kToolbarHeight,
                widget: const Icon(
                  Icons.arrow_drop_up_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const Sizer(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.PRIMARY_COLOR,
                size: 14,
              ),
              const Sizer(),
              Label(
                  text: 'By placing a bid you commit to buying',
                  style: Styles.mediumText(
                    color: AppColors.PRIMARY_COLOR,
                  )),
            ],
          ),
          AppButton(
              margin: 10,
              radius: 15,
              height: kToolbarHeight * .8,
              style: Styles.headerText(color: Colors.white),
              label: 'Place a bid',
              onPressed: () {}),
        ],
      ),
    );
  }
}
