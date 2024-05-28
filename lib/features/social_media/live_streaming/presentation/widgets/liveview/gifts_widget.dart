import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';
import 'recharge_coins.dart';

class GiftsWidget extends StatelessWidget {
  const GiftsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _buildGiftsWidget()),
        InkWell(
          onTap: () =>
              bottomSheet(context: context, widget: const RechargeCoins()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                Assets.coin,
                height: 20,
              ),
              const Sizer(),
              Label(
                text: 'Recharge',
                style: Styles.mediumText(color: Colors.white),
              ),
              const Icon(
                Icons.arrow_right_rounded,
                color: Colors.white,
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildGiftsWidget() {
    return GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) => _buildGiftItem());
  }

  Widget _buildGiftItem() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Image.asset(Assets.giftbox)),
          const Sizer(),
          Label(
            text: 'Fruit Friends',
            style: Styles.mediumText(color: Colors.white),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.monetization_on,
                color: AppColors.ACCENT_COLOR,
              ),
              const Sizer(),
              Label(
                text: '500',
                style: Styles.mediumText(color: Colors.white),
              )
            ],
          )
        ],
      ),
    );
  }
}
