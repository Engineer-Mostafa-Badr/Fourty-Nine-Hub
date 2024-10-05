import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/expired_requests_model.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:intl/intl.dart';

import '../cubit/restaurants_list_cubit.dart';

class RestaurantExpiredRequestsScreen extends StatelessWidget {
  const RestaurantExpiredRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RestaurantsCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.expiredRequests.tr(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        // backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: state.expiredRequestsResponse != null
          ? ListView.separated(
              itemCount: state.expiredRequestsResponse!.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TripRequestCard(
                      orderData: state.expiredRequestsResponse!.data![index]),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Sizer();
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class TripRequestCard extends StatelessWidget {
  final OrderData orderData;

  const TripRequestCard({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RestaurantsCubit>().state;
    return Card(
      elevation: isDarkTheme(context) ? 0 : 2,
      color: isDarkTheme(context) ? Colors.black26 : Colors.white,
      // margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      // decoration: BoxDecoration(
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(0.3),
      //       blurRadius: 4,
      //       offset: const Offset(0, 1), // changes position of shadow
      //     ),
      //   ],
      //   // color: Colors.white,
      //   // border: Border.all(
      //   //     color: AppColors.PRIMARY_COLOR,
      //   //     width: isDarkTheme(context) ? 3 : 1.5),
      //   borderRadius: BorderRadius.circular(15),
      // ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 65.w,
                  backgroundColor: Colors.grey[600],
                  backgroundImage: AssetImage(orderData.user!.gender == 'male'
                      ? Assets.maleImagePlaceholder
                      : Assets.femaleImagePlacehlder),
                ),
                SizedBox(width: 16.h),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        capitalizeAndSplit2Only(orderData.user!.firstName!),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 50),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     ElevatedButton(
                      //       onPressed: () {},
                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor: Colors.red,
                      //         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      //       ),
                      //       child: Text(
                      //         'بلاغ',
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 14,
                      //         ),
                      //       ),
                      //     ),
                      //     ElevatedButton(
                      //       onPressed: () {},
                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor: Colors.black,
                      //         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      //       ),
                      //       child: Text(
                      //         'رسالة',
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 14,
                      //         ),
                      //       ),
                      //     ),
                      //     ElevatedButton(
                      //       onPressed: () {},
                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor: Colors.black,
                      //         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      //       ),
                      //       child: Text(
                      //         'الاتصال',
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 14,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Container(
                      // color: Colors.red,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            capitalizeAndSplit2Only(
                                orderData.restaurant!.name!),
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.PRIMARY_COLOR_DARK,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            capitalizeAndSplit2Only(
                                orderData.restaurant!.subcategory!.nameEn!),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          orderData.orders!.length > 1
                              ? Text(
                                  "${orderData.orders![0].food!.foodName!}, ${orderData.orders![1].food!.foodName!}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600]),
                                )
                              : Text(
                                  orderData.orders![0].food!.foodName!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600]),
                                ),
                          Row(
                            children: [
                              Text(
                                orderData.total.toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600]),
                              ),
                              Text(
                                " ${orderData.currency}",
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.PRIMARY_COLOR_DARK),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  DateFormat('MMM d, yyyy h:mm a').format(orderData.createdAt!),
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.normal),
                ),
                const Spacer(),
                Flexible(
                  flex: 5,
                  child: Text(
                    orderData.subscriptionType.toString(),
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.SECONDARY_COLOR_DARK,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/expired_requests_model.dart';
// import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
// import 'package:fourtyninehub/res/assets/assets.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/res/style/const.dart';
// import 'package:intl/intl.dart';
//
// import '../cubit/restaurants_list_cubit.dart';
//
// class RestaurantExpiredRequestsScreen extends StatelessWidget {
//   const RestaurantExpiredRequestsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final state = context.watch<RestaurantsCubit>().state;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           LocaleKeys.expiredRequests.tr(),
//           style: TextStyle(
//             fontSize: 45.sp,
//             fontWeight: FontWeight.bold,
//             // shadows: [
//             //   const Shadow(
//             //       blurRadius: 1.0, color: Colors.black38, offset: Offset(0, 1))
//             // ],
//           ),
//         ),
//         // flexibleSpace: Container(
//         //   decoration: const BoxDecoration(
//         //     gradient: LinearGradient(
//         //       colors: [AppColors.PRIMARY_COLOR, AppColors.SECONDARY_COLOR],
//         //       begin: Alignment.topLeft,
//         //       end: Alignment.bottomRight,
//         //     ),
//         //   ),
//         // ),
//         elevation: 5,
//         centerTitle: true,
//       ),
//       body: state.expiredRequestsResponse != null
//           ? ListView.separated(
//               itemCount: state.expiredRequestsResponse!.data!.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.all(4.0),
//                   child: TripRequestCard(
//                     orderData: state.expiredRequestsResponse!.data![index],
//                   ),
//                 );
//               },
//               separatorBuilder: (BuildContext context, int index) {
//                 return const Sizer();
//               },
//             )
//           : const Center(
//               child: CircularProgressIndicator(),
//             ),
//     );
//   }
// }
//
// class TripRequestCard extends StatelessWidget {
//   final OrderData orderData;
//
//   const TripRequestCard({super.key, required this.orderData});
//
//   @override
//   Widget build(BuildContext context) {
//     final state = context.watch<RestaurantsCubit>().state;
//
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 500),
//       curve: Curves.easeInOut,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.white, Colors.grey.shade100],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: Colors.grey.withOpacity(0.3),
//           width: 1.5,
//         ),
//         // image: DecorationImage(
//         //   image: AssetImage(Assets.cardBackgroundPattern), // A light pattern or subtle image
//         //   fit: BoxFit.cover,
//         //   colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.1), BlendMode.dstATop),
//         // ),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 60.w,
//                 backgroundImage: AssetImage(Assets.femaleImagePlacehlder),
//               ),
//               SizedBox(width: 16.w),
//               Expanded(
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       capitalizeAndSplit2Only(orderData.user!.firstName!),
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Expanded(
//                       child: Center(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               capitalizeAndSplit2Only(
//                                   orderData.restaurant!.name!),
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 color: AppColors.PRIMARY_COLOR_DARK,
//                               ),
//                             ),
//                             Text(
//                               "kepda ${orderData.orders!.length > 1 ? '...' : ''}",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.grey[700],
//                                 fontStyle: FontStyle.italic,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Action icon for more options
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Text(
//                 "Total:",
//                 style: const TextStyle(
//                   fontSize: 18,
//                   color: AppColors.PRIMARY_COLOR,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Sizer(),
//               Row(
//                 children: [
//                   Text(
//                     "${orderData.total} ",
//                     style: const TextStyle(
//                       fontSize: 18,
//                       color: AppColors.PRIMARY_COLOR,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     "${orderData.currency}",
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.PRIMARY_COLOR_DARK,
//                     ),
//                   ),
//                 ],
//               ),
//               Spacer(
//                 flex: 4,
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           Divider(
//             color: Colors.grey[300],
//             thickness: 1,
//             height: 0,
//           ),
//           // A light divider
//           const SizedBox(height: 2),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 DateFormat('MMM d, yyyy h:mm a').format(orderData.createdAt!),
//                 style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//               ),
//               Chip(
//                 label: Text(
//                   orderData.subscriptionType.toString(),
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.white,
//                   ),
//                 ),
//                 backgroundColor: AppColors.PRIMARY_COLOR,
//               ),
//             ],
//           ),
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.end,
//           //   children: [
//           //     IconButton(
//           //       icon: Icon(Icons.call, color: AppColors.PRIMARY_COLOR),
//           //       onPressed: () {}, // Call action
//           //     ),
//           //     IconButton(
//           //       icon: Icon(Icons.message, color: AppColors.SECONDARY_COLOR),
//           //       onPressed: () {}, // Message action
//           //     ),
//           //     IconButton(
//           //       icon: Icon(Icons.report, color: Colors.redAccent),
//           //       onPressed: () {}, // Report action
//           //     ),
//           //   ],
//           // ),
//         ],
//       ),
//     );
//   }
// }
