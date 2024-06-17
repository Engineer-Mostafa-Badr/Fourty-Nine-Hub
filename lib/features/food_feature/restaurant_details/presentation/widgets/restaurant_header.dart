import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../restaurants_list/data/models/restaurant_model.dart';

class RestaurantHeader extends StatelessWidget {
  final RestaurantModel restaurant;
  const RestaurantHeader({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight * 4.5,
      width: double.infinity,
      child: Stack(
        children: [
          
          Positioned.fill(
              child: Column(
            children: [
              Expanded(
                  child: SquareImage(
                      width: double.infinity,
                      source: NetworkImage(restaurant.banner))),
              const Spacer(),
            ],
          )),
          Positioned(
            top: 10,
            left: 10,
            child: IconAppButton(
            icon: Icons.arrow_back,
            onPressed: () => context.pop(),
            isCircle: true,
          ),),
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
                        SizedBox(
                          height: kToolbarHeight,
                          width: kToolbarHeight,
                          child: SquareImage(
                              radius: 5,
                              source: NetworkImage(restaurant.image)),
                        ),
                        const Sizer(),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Label(
                              text: restaurant.name,
                              style: Styles.mediumText(
                                  fontWeight: FontWeight.w400),
                            ),
                            Label(
                                text: restaurant.description,
                                style: Styles.mediumText(color: Colors.grey)),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: AppColors.ACCENT_COLOR,
                                ),
                                const Sizer(),
                                Label(
                                    text: '${restaurant.rate} ',
                                    style: Styles.mediumText(
                                        fontWeight: FontWeight.w500)),
                                Label(
                                    text: '(${restaurant.numberOfReviews}+)',
                                    style: Styles.mediumText()),
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
                                    text: restaurant.deliveryTime,
                                    style: Styles.mediumText()),
                                const Sizer(),
                                const Icon(
                                  Icons.delivery_dining,
                                  color: Colors.grey,
                                ),
                                const Sizer(
                                  width: 5,
                                ),
                                Label(
                                    text:
                                        '${restaurant.deliveryFee != 0 ? restaurant.deliveryFee : "Free"}',
                                    style: Styles.mediumText())
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
                                label: 'Delivery Fee',
                                value:
                                    '${restaurant.deliveryFee != 0 ? restaurant.deliveryFee : "Free"}')),
                        Expanded(
                            child: _buildInfoItem(
                                label: 'Delivery time',
                                value: restaurant.deliveryTime)),
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
