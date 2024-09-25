import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_2_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/Images_profile_for_restaurant.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';
import 'package:go_router/go_router.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../routes/routes.dart';
import '../../domain/entities/restaurant_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubCatigoriesRestaurantCard extends StatelessWidget {
  final Restaurant2Model? item;
  final bool isVert;

  const SubCatigoriesRestaurantCard({super.key, this.isVert = true, this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => context.push(Routes.RESTAURANTDETAILS, extra: item?.id),
        child: isVert ? _buildVerticalCard(context) : _buildHorizontalCard());
  }

  Widget _buildVerticalCard(context) {
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width * 0.92,
      height: MediaQuery
          .of(context)
          .size
          .width * 1.1,
      // height: kToolbarHeight * 3,
      child: PropertyCard(item!)
      /* Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 1,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SquareImage(
                      radius: 5,
                      url: item?.image.first ?? "",
                    ),
                  ),
                  Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 2.h),
                        decoration: BoxDecoration(
                            color: AppColors.SECONDARY_COLOR,
                            borderRadius: BorderRadius.circular(5)),
                        child: Label(
                            text: '20% off some items',
                            style: Styles.smallText(color: Colors.white)),
                      ))
                ],
              )),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


              ],
            ),
          ),
        ],
      )*/
      ,
    );
  }

  Widget _buildHorizontalCard() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: SquareImage(
            radius: 5,
            url: item!.restaurantMedia!.first.mediaKey,
          ),
        ),
        const Sizer(),
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                  text: item?.name ?? "",
                  style: Styles.mediumText(fontWeight: FontWeight.w400),
                ),
                Label(
                    text: "", //item?.description,
                    style: Styles.mediumText(color: Colors.grey)),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.ACCENT_COLOR,
                    ),
                    const Sizer(),
                    Label(
                        text: '${item?.totalRating} ',
                        style: Styles.mediumText(fontWeight: FontWeight.w500)),
                    Label(
                        text: '(${item?.numberOfReviews}+)',
                        style: Styles.mediumText()),
                  ],
                ),
              ],
            ))
      ],
    );
  }
}

class PropertyCard extends StatefulWidget {
  final Restaurant2Model item;

  const PropertyCard(this.item, {super.key});

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to get the constraints of the parent widget
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
          ),
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.item.isPremium!) Expanded(
                  flex: 1, child: _buildEliteBanner(widget.item)),
              Flexible(
                flex: 4,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          widget.item.subcategoryId!.isFavorite!
                              ? Icons.favorite_border
                              : Icons.favorite,
                          color: AppColors.SECONDARY_COLOR,
                        ),
                        onPressed: () {
                          setState(() {
                            // widget.item.isFavorite = !item.isFavorite!;
                          });
                        },
                      ),
                    ),
                    const Positioned(
                      top: 10,
                      right: 10,
                      child: Icon(
                        Icons.verified,
                        color: AppColors.SECONDARY_COLOR,
                        size: 24.0, // Adjusted size for responsiveness
                      ),
                    ),
                    ImagesProfileForRestaurant(
                      autoPlay: true,
                      restaurantMedia: widget.item.restaurantMedia,
                    ),
                  ],
                ),
              ),
              Expanded(flex: 3, child: _buildDetailsSection(widget.item)),
              const SizedBox(height: 4),
              Expanded(flex: 1, child: PremiumAndRequestButtons(widget.item)),
              const SizedBox(height: 2),
              Expanded(flex: 1, child: CallMessageReportButtons(widget.item)),
              const SizedBox(height: 2),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEliteBanner(Restaurant2Model item) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFD4AF37), // Elite banner color
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
      child: const Text(
        'Premium',
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  // Widget _buildImageSection(Restaurant2Model item) {
  //   item.restaurantMedia!.forEach((element) {
  //     log("${element.mediaKey}************");
  //   });
  //   return Container(
  //     decoration: BoxDecoration(
  //       image: DecorationImage(
  //         fit: BoxFit.cover,
  //         image: NetworkImage(
  //           item.restaurantMedia.first.toString(), // Replace with your image URL
  //         ),
  //       ),
  //     ),
  //     child: Stack(
  //       children: [
  //         const Positioned(
  //           top: 10,
  //           right: 10,
  //           child: Icon(
  //             Icons.verified,
  //             color: AppColors.SECONDARY_COLOR,
  //             size: 24.0, // Adjusted size for responsiveness
  //           ),
  //         ),
  //         Positioned(
  //           top: 0,
  //           left: 0,
  //           child: IconButton(
  //             padding: EdgeInsets.zero,
  //             icon: Icon(
  //               item.isFavorite! ? Icons.favorite_border : Icons.favorite,
  //               color: AppColors.SECONDARY_COLOR,
  //             ),
  //             onPressed: () {
  //               setState(() {
  //                 item.isFavorite = !item.isFavorite!;
  //               });
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildDetailsSection(Restaurant2Model item) {
    return Container(
      // color: Colors.red,
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.name!,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              item.subcategoryId!.name + ", " +
                  (item.description ?? 'description...'),
              // 'القاهرة الجديدة, القاهرة',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            Text(
              '${item.government!.governorateNameEn.toString()}, ${item.city!
                  .cityNameEn.toString()}',
              // item.subcategoryId!.name ?? 'description',
              // 'القاهرة الجديدة, القاهرة',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.ACCENT_COLOR,
                    ),
                    Sizer(),
                    Label(
                        text: '${item.totalRating}',
                        style:
                        Styles.mediumText(fontWeight: FontWeight.w500)),
                    Label(
                        text: '(${item.numberOfReviews}+)',
                        style: Styles.mediumText()),
                  ],
                ),
                Text(
                  item.isActive! ? 'Available' : 'Not Available',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Premium and Request buttons
class PremiumAndRequestButtons extends StatelessWidget {
  final Restaurant2Model item;

  const PremiumAndRequestButtons(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          _buildButton(
            label: 'Premium Request',
            color: Colors.red,
            onPressed: () {},
          ),
          const SizedBox(width: 10),
          _buildButton(
            label: 'Request',
            color: Colors.black,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Flexible(
      child: AppButton(
          height: 60.h,
          label: label,
          backColor: color,
          style: Styles.mediumText(color: Colors.white),
          onPressed: onPressed),
    );
  }
}

// Call, Message, and Report buttons
class CallMessageReportButtons extends StatelessWidget {
  final Restaurant2Model item;

  const CallMessageReportButtons(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          _buildElevatedButtonWithIcon(
            label: 'Call',
            icon: Icons.call,
            onPressed: () {},
            color: Colors.grey,
          ),
          const SizedBox(width: 10),
          _buildElevatedButtonWithIcon(
            label: 'Message',
            icon: Icons.message,
            onPressed: () {},
            color: Colors.grey,
          ),
          const SizedBox(width: 10),
          _buildElevatedButtonWithIcon(
            label: 'Report',
            icon: Icons.report,
            color: Colors.red,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildElevatedButtonWithIcon({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
        child: AppButton(
            height: 60.h,
            label: label,
            icon: icon,
            iconSize: 70.h,
            backColor: color,
            style: Styles.mediumText(color: Colors.white),
            onPressed: onPressed));
  }
}

// class AutoScrollingImageCarousel extends StatefulWidget {
//   final Restaurant2Model item;
//
//   const AutoScrollingImageCarousel({Key? key, required this.item})
//       : super(key: key);
//
//   @override
//   _AutoScrollingImageCarouselState createState() =>
//       _AutoScrollingImageCarouselState();
// }
//
// class _AutoScrollingImageCarouselState
//     extends State<AutoScrollingImageCarousel> {
//   late PageController _pageController;
//   int _currentPage = 0;
//   late Timer _timer;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _pageController = PageController(initialPage: 0);
//
//     // Set a timer to automatically change the image every 3 seconds
//     _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
//       if (_currentPage < widget.item.restaurantMedia!.length - 1) {
//         _currentPage++;
//       } else {
//         _currentPage = 0;
//       }
//
//       _pageController.animateToPage(
//         _currentPage,
//         duration: Duration(milliseconds: 500), // Adjusted duration
//         curve: Curves.easeInOut,
//       );
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // height: 200.0, // Adjust based on your design
//       // width: double.infinity,
//       child: Stack(
//         children: [
//           // PageView for scrolling through images
//           PageView.builder(
//             controller: _pageController,
//             onPageChanged: (index) {
//               setState(() {
//                 _currentPage = index;
//               });
//             },
//             itemCount: widget.item.restaurantMedia?.length ?? 0,
//             itemBuilder: (context, index) {
//               final mediaKey = widget.item.restaurantMedia?[index].mediaKey;
//               return mediaKey != null
//                   ? Image.network(
//                       mediaKey,
//                       fit: BoxFit.scaleDown,
//                       // width: double.infinity,
//                     )
//                   : Container(); // Placeholder or error widget
//             },
//           ),
//           // Verified icon
//           Positioned(
//             top: 10,
//             right: 10,
//             child: Icon(
//               Icons.verified,
//               color: AppColors.SECONDARY_COLOR,
//               size: 24.0, // Adjusted size for responsiveness
//             ),
//           ),
//           // Favorite icon with toggle
//           Positioned(
//             top: 0,
//             left: 0,
//             child: IconButton(
//               padding: EdgeInsets.zero,
//               icon: Icon(
//                 widget.item.subcategoryId?.isFavorite == true
//                     ? Icons.favorite
//                     : Icons.favorite_border,
//                 color: AppColors.SECONDARY_COLOR,
//               ),
//               onPressed: () {
//                 setState(() {
//                   // Toggle favorite status here
//                 });
//               },
//             ),
//           ),
//           // Dots indicator at the bottom
//           Positioned(
//             bottom: 10,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 widget.item.restaurantMedia?.length ?? 0,
//                 (index) {
//                   return Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 2.0),
//                     width: _currentPage == index ? 12.0 : 8.0,
//                     height: _currentPage == index ? 12.0 : 8.0,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: _currentPage == index
//                           ? AppColors.SECONDARY_COLOR
//                           : Colors.grey,
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
