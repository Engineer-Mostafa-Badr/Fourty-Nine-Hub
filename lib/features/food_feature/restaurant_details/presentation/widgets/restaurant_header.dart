import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/Images_profile_for_restaurant.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class RestaurantHeader extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantHeader({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final double imageHeight = MediaQuery.of(context).size.width * 0.7;

    return SizedBox(
      width: double.infinity,
      height: imageHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Restaurant Images
          ImagesProfileForRestaurant(
            autoPlay: true,
            restaurantMedia: restaurant.restaurantMedia,
            heightCarousel: imageHeight,
            widthForImages: MediaQuery.of(context).size.width,
          ),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          // Restaurant Name and Rating
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name ?? '',
                  style: Styles.headerText(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.ACCENT_COLOR,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${restaurant.totalRating ?? '0.0'} ',
                      style: Styles.mediumText(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '(${restaurant.numberOfReviews ?? 0} ${LocaleKeys.reviews.localize})',
                      style: Styles.mediumText(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Back Button
          // Positioned(
          //   top: MediaQuery.of(context).padding.top + 10,
          //   left: 10,
          //   child: IconButton(
          //     icon: const Icon(Icons.arrow_back, color: Colors.white),
          //     onPressed: () => context.pop(),
          //     tooltip: 'Back',
          //   ),
          // ),
        ],
      ),
    );
  }
}
