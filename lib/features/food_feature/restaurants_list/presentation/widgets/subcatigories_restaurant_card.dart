// import 'dart:async';
// import 'dart:developer';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_2_model.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/meal_cubit/restaurants_meal_list_cubit.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/restaurants_list_cubit.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/Images_profile_for_restaurant.dart';
// import 'package:url_launcher/url_launcher_string.dart';
// import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
// import '../../../../../common/widgets/stateless/buttons/app_button.dart';
// import '../../../../../common/widgets/stateless/images/square_image.dart';
// import '../../../../../common/widgets/stateless/labels/label.dart';
// import '../../../../../core/enums/wallet_types_enums.dart';
// import '../../../../../res/style/const.dart';
// import '../../../../../res/style/styles.dart';
// import 'package:go_router/go_router.dart';
// import '../../../../../res/style/app_colors.dart';
// import '../../../../../routes/routes.dart';
// import '../../../../../service_locator/service_locator.dart';
// import '../../../../social_media/twitter/presentation/widgets/report_view.dart';
// import '../../../../subscripe/presentation/controllers/subscription_controller.dart';
// import '../../../../trip_join/view_all_trip_join/domain/entities/trip_join_card_entity.dart';
// import '../../../restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
// import '../../domain/entities/restaurant_entity.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class SubCatigoriesRestaurantCard extends StatefulWidget {
//   final Restaurant2Model? item;
//   final bool isVert;
//   final mealId;
//
//   const SubCatigoriesRestaurantCard(
//       {super.key, this.isVert = true, this.item, required this.mealId});
//
//   @override
//   State<SubCatigoriesRestaurantCard> createState() =>
//       _SubCatigoriesRestaurantCardState();
// }
//
// class _SubCatigoriesRestaurantCardState
//     extends State<SubCatigoriesRestaurantCard> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//         onTap: () =>
//             context.push(Routes.RESTAURANTDETAILS, extra: widget.item?.id),
//         child: widget.isVert
//             ? _buildVerticalCard(context)
//             : _buildHorizontalCard());
//   }
//
//   Widget _buildVerticalCard(context) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width * 0.92,
//       height: MediaQuery.of(context).size.width * 1.1,
//       // height: kToolbarHeight * 3,
//       child: PropertyCard(widget.item!, mealId: widget.mealId)
//       /* Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//               flex: 1,
//               child: Stack(
//                 children: [
//                   Positioned.fill(
//                     child: SquareImage(
//                       radius: 5,
//                       url: item?.image.first ?? "",
//                     ),
//                   ),
//                   Positioned(
//                       top: 10,
//                       left: 10,
//                       child: Container(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 10, vertical: 2.h),
//                         decoration: BoxDecoration(
//                             color: AppColors.SECONDARY_COLOR,
//                             borderRadius: BorderRadius.circular(5)),
//                         child: Label(
//                             text: '20% off some items',
//                             style: Styles.smallText(color: Colors.white)),
//                       ))
//                 ],
//               )),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//
//
//               ],
//             ),
//           ),
//         ],
//       )*/
//       ,
//     );
//   }
//
//   Widget _buildHorizontalCard() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           height: kToolbarHeight,
//           width: kToolbarHeight,
//           child: SquareImage(
//             radius: 5,
//             url: widget.item!.restaurantMedia!.first.mediaKey,
//           ),
//         ),
//         const Sizer(),
//         Expanded(
//             child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Label(
//               text: widget.item?.name ?? "",
//               style: Styles.mediumText(fontWeight: FontWeight.w400),
//             ),
//             Label(
//                 text: "", //item?.description,
//                 style: Styles.mediumText(color: Colors.grey)),
//             Row(
//               children: [
//                 const Icon(
//                   Icons.star_rounded,
//                   color: AppColors.ACCENT_COLOR,
//                 ),
//                 const Sizer(),
//                 Label(
//                     text: '${widget.item?.totalRating} ',
//                     style: Styles.mediumText(fontWeight: FontWeight.w500)),
//                 Label(
//                     text: '(${widget.item?.numberOfReviews}+)',
//                     style: Styles.mediumText()),
//               ],
//             ),
//           ],
//         ))
//       ],
//     );
//   }
// }
//
// class PropertyCard extends StatefulWidget {
//   final Restaurant2Model item;
//
//   final String? mealId;
//
//   const PropertyCard(this.item, {super.key, required this.mealId});
//
//   @override
//   State<PropertyCard> createState() => _PropertyCardState();
// }
//
// class _PropertyCardState extends State<PropertyCard> {
//   @override
//   Widget build(BuildContext context) {
//     // Use LayoutBuilder to get the constraints of the parent widget
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Card(
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(15.0),
//               topRight: Radius.circular(15.0),
//             ),
//           ),
//           elevation: 5,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (widget.item.subscriptionType!
//                       .split(' ')
//                       .first
//                       .toLowerCase() !=
//                   'no')
//                 Expanded(flex: 1, child: _buildEliteBanner(widget.item)),
//               Flexible(
//                 flex: 4,
//                 child: Stack(
//                   children: [
//                     ImagesProfileForRestaurant(
//                       autoPlay: true,
//                       restaurantMedia: widget.item.restaurantMedia,
//                     ),
//                     Positioned(
//                       top: 0,
//                       left: 0,
//                       child: IconButton(
//                         padding: EdgeInsets.zero,
//                         icon: Icon(
//                           widget.item.isFavorite!
//                               ? Icons.favorite
//                               : Icons.favorite_border,
//                           color: AppColors.SECONDARY_COLOR,
//                         ),
//                         onPressed: () async {
//                           log("${widget.item.isFavorite!}ascacsacac");
//                           await serviceLocator<RestaurantDetailsCubit>()
//                               .addRestaurantToFavorites(
//                                   context, widget.item.id!);
//
//                           if (widget.mealId!.isNotEmpty) {
//                             log("${widget.item.isFavorite!}ascacsacac");
//
//                             await BlocProvider.of<RestaurantsCubit>(context)
//                                 .getSubCategoryRestaurants(id: widget.mealId!);
//                           } else {
//                             await BlocProvider.of<RestaurantsCubit>(context)
//                                 .getAllRestaurant();
//                           }
//                           log("${widget.item.isFavorite!}ascacsacac");
//
//                           // setState(() {
//                           //   context
//                           //       .read<RestaurantsListCubit>()
//                           //       .toggleFavoriteSubcategory(
//                           //           widget.item.subcategoryId?.id ?? "");
//                           //   // widget.item.isFavorite = !item.isFavorite!;
//                           // });
//                         },
//                       ),
//                     ),
//                     false
//                         ? const Positioned(
//                             top: 10,
//                             right: 10,
//                             child: Icon(
//                               Icons.verified,
//                               color: AppColors.SECONDARY_COLOR,
//                               size: 24.0, // Adjusted size for responsiveness
//                             ),
//                           )
//                         : const Sizer(),
//                   ],
//                 ),
//               ),
//               Expanded(flex: 3, child: _buildDetailsSection(widget.item)),
//               const SizedBox(height: 4),
//               PremiumAndRequestButtons(widget.item),
//               const SizedBox(height: 4),
//               CallMessageReportButtons(widget.item),
//               const SizedBox(height: 2),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildEliteBanner(Restaurant2Model item) {
//     return Container(
//       width: double.infinity,
//       decoration: const BoxDecoration(
//         color: Color(0xFFD4AF37), // Elite banner color
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(15),
//           topRight: Radius.circular(15),
//         ),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
//       child: Text(
//         item.subscriptionType!.split(' ').first,
//         // 'Premium',
//         textAlign: TextAlign.start,
//         style: const TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           color: Colors.black,
//         ),
//       ),
//     );
//   }
//
//   // Widget _buildImageSection(Restaurant2Model item) {
//   //   item.restaurantMedia!.forEach((element) {
//   //     log("${element.mediaKey}************");
//   //   });
//   //   return Container(
//   //     decoration: BoxDecoration(
//   //       image: DecorationImage(
//   //         fit: BoxFit.cover,
//   //         image: NetworkImage(
//   //           item.restaurantMedia.first.toString(), // Replace with your image URL
//   //         ),
//   //       ),
//   //     ),
//   //     child: Stack(
//   //       children: [
//   //         const Positioned(
//   //           top: 10,
//   //           right: 10,
//   //           child: Icon(
//   //             Icons.verified,
//   //             color: AppColors.SECONDARY_COLOR,
//   //             size: 24.0, // Adjusted size for responsiveness
//   //           ),
//   //         ),
//   //         Positioned(
//   //           top: 0,
//   //           left: 0,
//   //           child: IconButton(
//   //             padding: EdgeInsets.zero,
//   //             icon: Icon(
//   //               item.isFavorite! ? Icons.favorite_border : Icons.favorite,
//   //               color: AppColors.SECONDARY_COLOR,
//   //             ),
//   //             onPressed: () {
//   //               setState(() {
//   //                 item.isFavorite = !item.isFavorite!;
//   //               });
//   //             },
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
//
//   Widget _buildDetailsSection(Restaurant2Model item) {
//     return Container(
//       // color: Colors.red,
//       width: double.infinity,
//       height: double.infinity,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Text(
//               item.name!,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               "${item.subcategoryId!.name}, ${item.description ?? 'description...'}",
//               // 'القاهرة الجديدة, القاهرة',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//               ),
//             ),
//             Text(
//               '${item.government!.governorateNameEn.toString()}, ${item.city!.cityNameEn.toString()}',
//               // item.subcategoryId!.name ?? 'description',
//               // 'القاهرة الجديدة, القاهرة',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[500],
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.star_rounded,
//                       color: AppColors.ACCENT_COLOR,
//                     ),
//                     const Sizer(),
//                     Label(
//                         text: '${item.totalRating}',
//                         style: Styles.mediumText(fontWeight: FontWeight.w500)),
//                     Label(
//                         text: '(${item.numberOfReviews}+)',
//                         style: Styles.mediumText()),
//                   ],
//                 ),
//                 Text(
//                   item.isActive! ? 'Available' : 'Not Available',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // Premium and Request buttons
// class PremiumAndRequestButtons extends StatelessWidget {
//   final Restaurant2Model item;
//
//   const PremiumAndRequestButtons(this.item, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
//       child: Row(
//         children: [
//           _buildButton(
//             label: 'Premium Request',
//             color: AppColors.PRIMARY_COLOR_DARK,
//             onPressed: () async {
//               serviceLocator<SubscriptionController>().checkIfUserSubscribed(
//                 showRegular: false,
//                 title: "${item.subcategoryId!.name} Subscription",
//                 onSubscribed: () {
//                   print('Subscribed');
//                   context.push(Routes.RESTAURANTDETAILS, extra: item.id);
//                 },
//                 subCategoryId: item.subcategoryId!.id,
//               );
//               // await serviceLocator<SubscriptionController>()
//               //     .showSubscriptionPlans(
//               //         subCategoryId: item.subcategoryId!.id,
//               //         wallets: [
//               //       WalletTypes.mainWallet,
//               //       WalletTypes.giftWallet,
//               //       WalletTypes.balance
//               //     ]);
//             },
//           ),
//           const SizedBox(width: 4),
//           _buildButton(
//             label: 'Request',
//             color: AppColors.PRIMARY_COLOR,
//             onPressed: () {
//               context.push(Routes.RESTAURANTDETAILS, extra: item.id);
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildButton({
//     required String label,
//     required Color color,
//     required VoidCallback onPressed,
//   }) {
//     return Flexible(
//       child: AppButton(
//           height: 60.h,
//           padding: 0,
//           margin: 0,
//           label: label,
//           backColor: color,
//           style: Styles.mediumText(color: Colors.white),
//           onPressed: onPressed),
//     );
//   }
// }
//
// // Call, Message, and Report buttons
// class CallMessageReportButtons extends StatelessWidget {
//   final Restaurant2Model item;
//
//   const CallMessageReportButtons(this.item, {super.key});
//
//   Future<bool> _userApproved(TripJoinCardEntity tripJoinCardEntity,
//       String subCategoryId, String title) async {
//     if (tripJoinCardEntity.isApproved == null ||
//         tripJoinCardEntity.isApproved == false) {
//       await serviceLocator<SubscriptionController>().showSubscriptionPlans(
//         wallets: [WalletTypes.balance],
//         subCategoryId: subCategoryId,
//         title: title,
//       );
//       return false;
//     }
//     return false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
//       child: Row(
//         children: [
//           _buildElevatedButtonWithIcon(
//             label: 'Call',
//             icon: Icons.call,
//             onPressed: item.enableOrDisableChat != 'disable'
//                 ? () async {
//                     log('enable--------------');
//                     launchUrlString("tel://${item.number}");
//
//                     // if (await _userApproved(
//                     //   tripJoinCardEntity,
//                     //   UIConst.chatNormalId,
//                     //   'Chat Subscription',
//                     // )) {
//                     //   launchUrlString("tel://${tripJoinCardEntity.phone}");
//                     // }
//                   }
//                 : () {},
//             color: AppColors.GREY_DARK_COLOR,
//           ),
//           const SizedBox(width: 4),
//           _buildElevatedButtonWithIcon(
//             label: 'Message',
//             icon: Icons.message,
//             onPressed: item.enableOrDisableChat != 'disable'
//                 ? () async {
//                     log('enable--------------');
//
//                     //   launchUrlString("tel://${tripJoinCardEntity.phone}");
//
//                     // if (await _userApproved(
//                     //   tripJoinCardEntity,
//                     //   UIConst.chatNormalId,
//                     //   'Chat Subscription',
//                     // )) {
//                     //   launchUrlString("tel://${tripJoinCardEntity.phone}");
//                     // }
//                   }
//                 : () {},
//             color: AppColors.GREY_DARK_COLOR,
//           ),
//           const SizedBox(width: 4),
//           _buildElevatedButtonWithIcon(
//             label: 'Report',
//             icon: Icons.report,
//             color: AppColors.PRIMARY_COLOR_DARK,
//             onPressed: () {
//               bottomSheet(
//                 context: context,
//                 widget: ReportView(
//                   id: item.id!,
//                   categoryId: item.subcategoryId!.id,
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildElevatedButtonWithIcon({
//     required String label,
//     required IconData icon,
//     required Color color,
//     required VoidCallback onPressed,
//   }) {
//     return Expanded(
//         child: AppButton(
//             padding: 0,
//             margin: 0,
//             height: 60.h,
//             label: label,
//             icon: icon,
//             iconSize: 70.h,
//             backColor: color,
//             style: Styles.mediumText(color: Colors.white),
//             onPressed: onPressed));
//   }
// }
//
// // class AutoScrollingImageCarousel extends StatefulWidget {
// //   final Restaurant2Model item;
// //
// //   const AutoScrollingImageCarousel({Key? key, required this.item})
// //       : super(key: key);
// //
// //   @override
// //   _AutoScrollingImageCarouselState createState() =>
// //       _AutoScrollingImageCarouselState();
// // }
// //
// // class _AutoScrollingImageCarouselState
// //     extends State<AutoScrollingImageCarousel> {
// //   late PageController _pageController;
// //   int _currentPage = 0;
// //   late Timer _timer;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //
// //     _pageController = PageController(initialPage: 0);
// //
// //     // Set a timer to automatically change the image every 3 seconds
// //     _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
// //       if (_currentPage < widget.item.restaurantMedia!.length - 1) {
// //         _currentPage++;
// //       } else {
// //         _currentPage = 0;
// //       }
// //
// //       _pageController.animateToPage(
// //         _currentPage,
// //         duration: Duration(milliseconds: 500), // Adjusted duration
// //         curve: Curves.easeInOut,
// //       );
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     _timer.cancel();
// //     _pageController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       // height: 200.0, // Adjust based on your design
// //       // width: double.infinity,
// //       child: Stack(
// //         children: [
// //           // PageView for scrolling through images
// //           PageView.builder(
// //             controller: _pageController,
// //             onPageChanged: (index) {
// //               setState(() {
// //                 _currentPage = index;
// //               });
// //             },
// //             itemCount: widget.item.restaurantMedia?.length ?? 0,
// //             itemBuilder: (context, index) {
// //               final mediaKey = widget.item.restaurantMedia?[index].mediaKey;
// //               return mediaKey != null
// //                   ? Image.network(
// //                       mediaKey,
// //                       fit: BoxFit.scaleDown,
// //                       // width: double.infinity,
// //                     )
// //                   : Container(); // Placeholder or error widget
// //             },
// //           ),
// //           // Verified icon
// //           Positioned(
// //             top: 10,
// //             right: 10,
// //             child: Icon(
// //               Icons.verified,
// //               color: AppColors.SECONDARY_COLOR,
// //               size: 24.0, // Adjusted size for responsiveness
// //             ),
// //           ),
// //           // Favorite icon with toggle
// //           Positioned(
// //             top: 0,
// //             left: 0,
// //             child: IconButton(
// //               padding: EdgeInsets.zero,
// //               icon: Icon(
// //                 widget.item.subcategoryId?.isFavorite == true
// //                     ? Icons.favorite
// //                     : Icons.favorite_border,
// //                 color: AppColors.SECONDARY_COLOR,
// //               ),
// //               onPressed: () {
// //                 setState(() {
// //                   // Toggle favorite status here
// //                 });
// //               },
// //             ),
// //           ),
// //           // Dots indicator at the bottom
// //           Positioned(
// //             bottom: 10,
// //             left: 0,
// //             right: 0,
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: List.generate(
// //                 widget.item.restaurantMedia?.length ?? 0,
// //                 (index) {
// //                   return Container(
// //                     margin: const EdgeInsets.symmetric(horizontal: 2.0),
// //                     width: _currentPage == index ? 12.0 : 8.0,
// //                     height: _currentPage == index ? 12.0 : 8.0,
// //                     decoration: BoxDecoration(
// //                       shape: BoxShape.circle,
// //                       color: _currentPage == index
// //                           ? AppColors.SECONDARY_COLOR
// //                           : Colors.grey,
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/restaurants_list_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/Images_profile_for_restaurant.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../social_media/twitter/presentation/widgets/report_view.dart';
import '../../../../subscripe/presentation/controllers/subscription_controller.dart';
import '../../../restaurant_details/presentation/cubit/restaurant_details_cubit.dart';

class SubCategoriesRestaurantCard extends StatelessWidget {
  final Restaurant? item;
  final bool isVertical;
  final String mealId;

  const SubCategoriesRestaurantCard({
    super.key,
    this.isVertical = true,
    this.item,
    required this.mealId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.RESTAURANTDETAILS, extra: item?.id),
      child: isVertical
          ? VerticalRestaurantCard(item: item, mealId: mealId)
          : HorizontalRestaurantCard(item: item),
    );
  }
}

class VerticalRestaurantCard extends StatelessWidget {
  final Restaurant? item;
  final String mealId;

  const VerticalRestaurantCard({super.key, this.item, required this.mealId});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.92,
      height: MediaQuery.of(context).size.width * 1.1,
      child: PropertyCard(
        item: item!,
        mealId: mealId,
        myRestaurant: false,
      ),
    );
  }
}

class HorizontalRestaurantCard extends StatelessWidget {
  final Restaurant? item;

  const HorizontalRestaurantCard({super.key, this.item});

  @override
  Widget build(BuildContext context) {
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
                text: item?.description ?? "",
                style: Styles.mediumText(color: Colors.grey),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.ACCENT_COLOR,
                  ),
                  const Sizer(),
                  Label(
                    text: '${item?.totalRating} ',
                    style: Styles.mediumText(fontWeight: FontWeight.w500),
                  ),
                  Label(
                    text: '(${item?.numberOfReviews}+)',
                    style: Styles.mediumText(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Restaurant item;
  final String mealId;
  final bool myRestaurant;

  const PropertyCard(
      {super.key,
      required this.item,
      required this.mealId,
      required this.myRestaurant});

  @override
  Widget build(BuildContext context) {
    final hasSubscription =
        item.subscriptionType?.split(' ').first.toLowerCase() != 'no';
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          clipBehavior: Clip.hardEdge,
          color: cardDarkColor(context),
          elevation: myRestaurant ? 0 : 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasSubscription)
                EliteBanner(subscriptionType: item.subscriptionType!),
              Flexible(
                flex: 4,
                child: Stack(
                  children: [
                    ImagesProfileForRestaurant(
                      autoPlay: true,
                      restaurantMedia: item.restaurantMedia,
                    ),
                    if (!myRestaurant && context.read<UserCubit>().isLoggedIn)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: FavoriteButton(item: item, mealId: mealId),
                      ),
                    // if (item.isVerified ?? false)
                    if (false)
                      const Positioned(
                        top: 10,
                        right: 10,
                        child: Icon(
                          Icons.verified,
                          color: AppColors.SECONDARY_COLOR,
                          size: 24.0,
                        ),
                      ),
                  ],
                ),
              ),
              Flexible(
                  flex: 3,
                  child:
                      DetailsSection(item: item, myRestaurant: myRestaurant)),
              if (!myRestaurant) const SizedBox(height: 4),
              if (!myRestaurant) PremiumAndRequestButtons(item: item),
              if (!myRestaurant) const SizedBox(height: 4),
              if (!myRestaurant) CallMessageReportButtons(item: item),
              if (!myRestaurant) const SizedBox(height: 2),
              // CallMessageButtons(
              //     otherUserId: item.userIdModel!.id??''!,
              //     subcategoryId: item.subcategoryId!.id,
              //     phone: item.number!,
              //     id: item.id!),
            ],
          ),
        );
      },
    );
  }
}

class EliteBanner extends StatelessWidget {
  final String subscriptionType;

  const EliteBanner({super.key, required this.subscriptionType});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFD4AF37),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
      child: Text(
        subscriptionType.split(' ').first,
        textAlign: TextAlign.start,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  final Restaurant item;
  final String mealId;

  const FavoriteButton({super.key, required this.item, required this.mealId});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        item.isFavorite! ? Icons.favorite : Icons.favorite_border,
        color: AppColors.SECONDARY_COLOR,
      ),
      onPressed: () async {
        await serviceLocator<RestaurantDetailsCubit>()
            .addRestaurantToFavorites(context, item.id!);

        if (mealId.isNotEmpty) {
          await BlocProvider.of<RestaurantsCubit>(context)
              .getSubCategoryRestaurants(id: mealId);
        } else {
          await BlocProvider.of<RestaurantsCubit>(context).getAllRestaurant();
        }
      },
    );
  }
}

class DetailsSection extends StatelessWidget {
  final Restaurant item;

  final bool myRestaurant;

  const DetailsSection(
      {super.key, required this.item, required this.myRestaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(child: Text(item.name ?? '', style: Styles.headerText())),
          Expanded(
            child: Text(
                "${item.subcategoryId?.name ?? ''}, ${item.description ?? ''}",
                style: Styles.mediumText(
                    fontWeight: FontWeight.w600, fontSize: 30)),
          ),
          if (myRestaurant)
            Expanded(
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      '${item.government?.governorateNameEn ?? ''}, ${item.city?.cityNameEn ?? ''}',
                      style: Styles.mediumText()),
                  const Spacer(),
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.ACCENT_COLOR,
                  ),
                  const Sizer(),
                  Label(
                    text: '${item.totalRating}',
                    style: Styles.mediumText(fontWeight: FontWeight.w500),
                  ),
                  Label(
                    text: '(${item.numberOfReviews}+)',
                    style: Styles.mediumText(),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: Text(
                  '${item.government?.governorateNameEn ?? ''}, ${item.city?.cityNameEn ?? ''}',
                  style: Styles.mediumText()),
            ),
          if (!myRestaurant)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.ACCENT_COLOR,
                      ),
                      const Sizer(),
                      Label(
                        text: '${item.totalRating}',
                        style: Styles.mediumText(fontWeight: FontWeight.w500),
                      ),
                      Label(
                        text: '(${item.numberOfReviews}+)',
                        style: Styles.mediumText(),
                      ),
                    ],
                  ),
                  if (!myRestaurant)
                    Text(item.isActive! ? 'Available' : 'Not Available',
                        style: Styles.headerText(
                            color: AppColors.SECONDARY_COLOR)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class PremiumAndRequestButtons extends StatelessWidget {
  final Restaurant item;

  const PremiumAndRequestButtons({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
      child: Row(
        children: [
          _buildButton(
            label: 'Premium Request',
            color: AppColors.PRIMARY_COLOR_DARK,
            onPressed: () async {
              serviceLocator<SubscriptionController>().checkIfUserSubscribed(
                showRegular: false,
                title: "${item.subcategoryId!.name} Subscription",
                onSubscribed: () {
                  context.push(Routes.RESTAURANTDETAILS, extra: item.id);
                },
                subCategoryId: item.subcategoryId!.id,
              );
            },
          ),
          const SizedBox(width: 4),
          _buildButton(
            label: 'Request',
            color: AppColors.PRIMARY_COLOR,
            onPressed: () {
              context.push(Routes.RESTAURANTDETAILS, extra: item.id);
            },
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
        padding: 0,
        margin: 0,
        label: label,
        backColor: color,
        style: Styles.mediumText(color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}

class CallMessageReportButtons extends StatelessWidget {
  final Restaurant item;

  const CallMessageReportButtons({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isChatEnabled = item.enableOrDisableChat != 'disable';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
      child: Row(
        children: [
          _buildButtonWithIcon(
            label: 'Call',
            icon: Icons.call,
            color: AppColors.GREY_DARK_COLOR,
            onPressed: isChatEnabled
                ? () => launchUrlString("tel://${item.number}")
                : () {},
          ),
          const SizedBox(width: 4),
          _buildButtonWithIcon(
            label: 'Message',
            icon: Icons.message,
            color: AppColors.GREY_DARK_COLOR,
            onPressed: isChatEnabled
                ? () {
                    BlocProvider.of<RestaurantsCubit>(context)
                        .getExpiredOrders();
                    // Implement message functionality here
                  }
                : () {},
          ),
          const SizedBox(width: 4),
          _buildButtonWithIcon(
            label: 'Report',
            icon: Icons.report,
            color: AppColors.PRIMARY_COLOR_DARK,
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return SizedBox(
                    height: isKeyboardVisible(context) ? 0.8.sh : 0.6.sh,
                    child: ReportView(
                      id: item.id!,
                      categoryId: item.subcategoryId!.id,
                    ),
                  );
                },
              );

              // Implement report functionality here
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButtonWithIcon({
    required String label,
    required IconData icon,
    required Color color,
    required Function onPressed,
  }) {
    return Expanded(
      child: AppButton(
        padding: 0,
        margin: 0,
        height: 60.h,
        label: label,
        icon: icon,
        iconSize: 70.h,
        backColor: color,
        style: Styles.mediumText(color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
