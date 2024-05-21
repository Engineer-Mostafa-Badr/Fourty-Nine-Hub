import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/const.dart';
import '../../../../../res/style/styles.dart';
import 'package:go_router/go_router.dart';

import '../../../../../res/style/app_colors.dart';
import '../../../../../routes/routes.dart';

class RestaurantCard extends StatelessWidget {
  final bool isVert;
  const RestaurantCard({super.key, this.isVert = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => context.push(Routes.RESTAURANTDETAILS),
        child: isVert ? _buildVerticalCard() : _buildHorizontalCard());
  }

  Widget _buildVerticalCard() {
    return SizedBox(
      width: kToolbarHeight * 2.5,
      height: kToolbarHeight * 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Stack(
            children: [
              const Positioned.fill(
                child: SquareImage(
                    radius: 5,
                    source: NetworkImage(UIConst.restaurantPlaceHolder)),
              ),
              Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                        color: AppColors.SECONDARY_COLOR,
                        borderRadius: BorderRadius.circular(5)),
                    child: Label(
                        text: '20% off some items',
                        style: Styles.smallText(color: Colors.white)),
                  ))
            ],
          )),
          Label(
            text: 'Bazooka',
            style: Styles.mediumText(fontWeight: FontWeight.w400),
          ),
          Label(
              text: 'Burger, Chicken',
              style: Styles.mediumText(color: Colors.grey)),
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: AppColors.ACCENT_COLOR,
              ),
              const Sizer(),
              Label(
                  text: '4.4 ',
                  style: Styles.mediumText(fontWeight: FontWeight.w500)),
              Label(text: '(100+)', style: Styles.mediumText()),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHorizontalCard() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: SquareImage(
              radius: 5, source: NetworkImage(UIConst.restaurantPlaceHolder)),
        ),
        const Sizer(),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(
              text: 'Bazooka',
              style: Styles.mediumText(fontWeight: FontWeight.w400),
            ),
            Label(
                text: 'Burger, Chicken',
                style: Styles.mediumText(color: Colors.grey)),
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.ACCENT_COLOR,
                ),
                const Sizer(),
                Label(
                    text: '4.4 ',
                    style: Styles.mediumText(fontWeight: FontWeight.w500)),
                Label(text: '(100+)', style: Styles.mediumText()),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: Colors.grey,
                ),
                const Sizer(
                  width: 5,
                ),
                Label(text: '38 mins', style: Styles.mediumText()),
                const Sizer(),
                const Icon(
                  Icons.delivery_dining,
                  color: Colors.grey,
                ),
                const Sizer(
                  width: 5,
                ),
                Label(text: 'Free', style: Styles.mediumText())
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.local_offer_outlined,
                  color: AppColors.SECONDARY_COLOR,
                ),
                const Sizer(
                  width: 5,
                ),
                Label(
                    text: '20% off some items',
                    style: Styles.mediumText(color: AppColors.SECONDARY_COLOR))
              ],
            )
          ],
        ))
      ],
    );
  }
}
