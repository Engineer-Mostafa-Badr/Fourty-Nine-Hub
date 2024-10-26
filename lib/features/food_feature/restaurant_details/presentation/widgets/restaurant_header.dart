// import 'package:flutter/material.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/Images_profile_for_restaurant.dart';
// import 'package:go_router/go_router.dart';
// import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
// import '../../../../../common/widgets/stateless/images/square_image.dart';
// import '../../../../../common/widgets/dynamic/sizer.dart';
// import '../../../../../common/widgets/stateless/labels/label.dart';
// import '../../../../../res/style/app_colors.dart';
// import '../../../../../res/style/styles.dart';
//
// class RestaurantHeader extends StatelessWidget {
//   final Restaurant restaurant;
//   const RestaurantHeader({super.key, required this.restaurant});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       // height: kToolbarHeight,
//       width: double.infinity,
//       child: Stack(
//         children: [
//           Column(
//             children: [
//               ImagesProfileForRestaurant(
//                 autoPlay: true,
//                 restaurantMedia: restaurant.restaurantMedia,
//                 heightCarousel: MediaQuery.of(context).size.width * 0.5,
//                 widthForImages: MediaQuery.of(context).size.width,
//               ),
//
//               /// card data
//               SizedBox(
//                 height: kToolbarHeight * 1.9,
//                 child: Card(
//                   margin: const EdgeInsets.all(15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(0),
//                   ),
//                   elevation: 5,
//                   color: Theme.of(context).scaffoldBackgroundColor,
//                   child: Container(
//                     color: Theme.of(context).scaffoldBackgroundColor,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SquareImage(
//                                 width: kToolbarHeight * 2,
//                                 height: kToolbarHeight,
//                                 fit: BoxFit.cover,
//                                 url:
//                                     restaurant.restaurantMedia?.first.mediaKey),
//                             Sizer(),
//                             Expanded(
//                                 child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Label(
//                                   text: restaurant.name ?? "",
//                                   style: Styles.headerText(
//                                       fontWeight: FontWeight.bold,
//                                       color: AppColors.PRIMARY_COLOR_DARK),
//                                 ),
//                                 Row(
//                                   children: [
//                                     const Icon(
//                                       Icons.star_rounded,
//                                       color: AppColors.ACCENT_COLOR,
//                                     ),
//                                     Sizer(),
//                                     Label(
//                                         text:
//                                             '${restaurant.totalRating ?? ""} ',
//                                         style: Styles.mediumText(
//                                             fontWeight: FontWeight.w500)),
//                                     Label(
//                                         text:
//                                             '(${restaurant.numberOfReviews}+)',
//                                         style: Styles.mediumText()),
//                                   ],
//                                 ),
//                               ],
//                             ))
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           /// back botton
//           Positioned(
//             top: 10,
//             left: 10,
//             child: IconAppButton(
//               icon: Icons.arrow_back,
//               onPressed: () => context.pop(),
//               isCircle: true,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoItem({
//     required String label,
//     required String value,
//   }) {
//     return Column(
//       children: [
//         Label(text: label, style: Styles.mediumText(color: Colors.grey)),
//         // Sizer(),
//         Label(text: value, style: Styles.mediumText())
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
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
                      '(${restaurant.numberOfReviews ?? 0} Reviews)',
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
