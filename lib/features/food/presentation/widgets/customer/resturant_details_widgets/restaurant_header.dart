import 'package:flutter/material.dart';
import '../../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../../res/style/const.dart';

import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';

class RestaurantHeader extends StatelessWidget {
  const RestaurantHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight * 4.5,
      width: double.infinity,
      child: Stack(
        children: [
          const Positioned.fill(
              child: Column(
            children: [
              Expanded(
                  child: SquareImage(
                      width: double.infinity,
                      source: NetworkImage(UIConst.restaurantPlaceHolder))),
              Spacer(),
            ],
          )),
          Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              top: kToolbarHeight * 1,
              child: Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: kToolbarHeight,
                          width: kToolbarHeight,
                          child: SquareImage(
                              radius: 5,
                              source:
                                  NetworkImage(UIConst.restaurantPlaceHolder)),
                        ),
                        const Sizer(),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Label(
                              text: 'Bazooka',
                              style: Styles.mediumText(
                                  fontWeight: FontWeight.w400),
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
                                    style: Styles.mediumText(
                                        fontWeight: FontWeight.w500)),
                                Label(
                                    text: '(100+)', style: Styles.mediumText()),
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
                                Label(
                                    text: '38 mins',
                                    style: Styles.mediumText()),
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
                          ],
                        ))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: _buildInfoItem(
                                label: 'Delivery Fee', value: 'Free')),
                        Expanded(
                            child: _buildInfoItem(
                                label: 'Delivery time', value: '23 mins')),
                        Expanded(
                            child: _buildInfoItem(
                                label: 'Certified', value: 'by 49Hub')),
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
                            style: Styles.mediumText(
                                color: AppColors.SECONDARY_COLOR))
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Label(text: label, style: Styles.mediumText(color: Colors.grey)),
        // const Sizer(),
        Label(text: value, style: Styles.mediumText())
      ],
    );
  }
}
