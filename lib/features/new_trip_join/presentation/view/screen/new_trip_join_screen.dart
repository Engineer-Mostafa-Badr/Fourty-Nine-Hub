import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/core/utils/handle_cashback.dart';
import 'package:fourtyninehub/features/new_trip_join/presentation/view/widget/new_trip_join_body.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class NewTripJoinScreen extends StatefulWidget {
  const NewTripJoinScreen({super.key});

  @override
  State<NewTripJoinScreen> createState() => _NewTripJoinScreenState();
}

class _NewTripJoinScreenState extends State<NewTripJoinScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: HomeAppbar(
        isWithBackArrow: false,
        language: true,
        leading: IconButton(
          icon: const Icon(Icons.menu), // The menu icon
          onPressed: () {
            HandleCashback.setCount('drawerCount', context);
            _scaffoldKey.currentState?.openDrawer(); // Open the drawer
          },
        ),
      ),
      body: NewTripJoinBody(),
    );
  }
}

// class TripJoinView extends StatefulWidget {
//   const TripJoinView({super.key});

//   @override
//   State<TripJoinView> createState() => _TripJoinViewState();
// }

// class _TripJoinViewState extends State<TripJoinView> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: CustomScaffold(
//         appBar: HomeAppbar(
//           showChat: true,
//           isWithBackArrow: false,
//           language: true,
//           leading: IconButton(
//             icon: const Icon(Icons.menu), // The menu icon
//             onPressed: () {
//               HandleCashback.setCount('drawerCount', context);
//               _scaffoldKey.currentState?.openDrawer(); // Open the drawer
//             },
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Column(
//                 children: [
//                   Padding(
//                     padding:
//                         EdgeInsets.symmetric(vertical: 30.h, horizontal: 32.h),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         _buildCategoryIcons(
//                             image: Assets.tripJoinCaptainShare,
//                             title: context.isArabic
//                                 ? "مشاركة كابتن"
//                                 : "Captain\n Share"),
//                         _buildCategoryIcons(
//                             image: Assets.tripJoinIconSelected,
//                             title: context.isArabic ? "جاي معاك" : "Trip Join"),
//                         _buildCategoryIcons(
//                             image: Assets.tripJoinPickMe,
//                             title: context.isArabic ? "وصلني معاك" : "Pick me"),
//                       ],
//                     ),
//                   ),
//                   _buildStatusCategories(),
//                   SizedBox(
//                     height: 10.h,
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 32.0.h),
//                 child: ListView.builder(
//                     physics: const NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: 2,
//                     itemBuilder: (BuildContext context, int index) {
//                       return const
//                           // AvailableTripCard(
//                           //   time: '8:00 Pm',
//                           //   seats: 2,
//                           //   status: 'Repeat',
//                           // );
//                           // MyAdsTripCard(
//                           //   name: 'Kia, Cerato',
//                           //       isMale: true,
//                           //       time: '8:00 Pm',
//                           //       seats: 2,
//                           //       status: 'One Time',);
//                           RequestsTripCard(
//                         name: 'Mohamed',
//                         isMale: true,
//                         time: '8:00 Pm',
//                         seats: 2,
//                         status: 'Expired',
//                       );
//                     }),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   _buildCategoryIcons({required String image, required String title}) {
//     return Container(
//       child: Column(
//         children: [
//           Image.asset(
//             image,
//           ),
//           Text(
//             title,
//             style: Styles.headerText(),
//           ),
//         ],
//       ),
//     );
//   }

//   _buildStatusCategories() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 32.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: _buildCategory(
//                 title: context.isArabic ? "الرحلات المتاحة" : "Available Trips",
//                 selected: false),
//           ),
//           SizedBox(
//             width: 10.h,
//           ),
//           Expanded(
//             child: _buildCategory(
//                 title: context.isArabic ? "طلبات التوصيل" : "Ride Requests",
//                 selected: false),
//           ),
//           SizedBox(
//             width: 10.h,
//           ),
//           Expanded(
//             child: _buildCategory(
//                 title: context.isArabic ? "اعلاناتي" : "My Ads",
//                 selected: true),
//           ),
//         ],
//       ),
//     );
//   }

//   _buildCategory({required String title, required bool selected}) {
//     return InkWell(
//       onTap: ()=>JoinTripBottomSheet(context),
//       child: Stack(
//         children: [
//           //Positioned(child: child),
//           Container(
//             // margin: EdgeInsets.symmetric(horizontal :10.h),
//             width: double.maxFinite,
//             padding: EdgeInsets.symmetric(
//               vertical: 12.h,
//             ),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(40.h),
//                 color: selected ? AppColors.PRIMARY_COLOR : AppColors.GREYBG,
//                 border: Border.all(
//                     color: selected
//                         ? AppColors.SECONDARY_COLOR
//                         : AppColors.c0B1035,
//                     width: 2)),
//             child: Center(
//               child: Text(
//                 title,
//                 style: Styles.headerText(
//                     fontSize: 24,
//                     color: selected ? Colors.white : AppColors.black),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
