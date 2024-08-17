import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

import '../../../restaurants_list/domain/entities/restaurant_entity.dart';

class RestaurantHeader extends StatelessWidget {
  final RestaurantEntity restaurant;
  const RestaurantHeader({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight * 4,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
              child: Column(
            children: [
              Expanded(
                  child: SquareImage(
                      width: double.infinity, url: restaurant.image.first)),
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
            ),
          ),
          Positioned(
              bottom: 0,
              left: 10,
              right: 10,
              height: kToolbarHeight * 2,
              child: Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey, spreadRadius: 6, blurRadius: 10)
                    ],
                    color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: kToolbarHeight,
                          width: kToolbarHeight,
                          child: SquareImage(
                              radius: 5, url: restaurant.image.first),
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
                          ],
                        ))
                      ],
                    ),
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
