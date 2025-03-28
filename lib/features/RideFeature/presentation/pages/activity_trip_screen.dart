import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/car_circle_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/info_column_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/rebook_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

import '../../../../res/style/app_colors.dart';

// ignore: must_be_immutable
class ActivityTripScreen extends StatelessWidget {
   ActivityTripScreen({super.key});

  List<String> images = [
    Assets.redCar,
    Assets.blackCar,
    Assets.redCar,
    Assets.blackCar,
    Assets.redCar,
    Assets.blackCar,
    Assets.redCar,
    Assets.blackCar,
  ];
  List<String> titles = [
    "Women",
    "Captain",
    "Women",
    "Captain",
    "Women",
    "Captain",
    "Women",
    "Captain",
  ];
  List<String> columnTitle = [
    "142 Street 53",
    "142 Street 53",
    "142 Street 53",
    "142 Street 53",
    "142 Street 53",
    "142 Street 53",
    "142 Street 53",
    "142 Street 53",
  ];
  List<String> columnDate = [
    "Feb 13 - 12:41 PM",
    "Feb 13 - 12:41 PM",
    "Feb 13 - 12:41 PM",
    "Feb 13 - 12:41 PM",
    "Feb 13 - 12:41 PM",
    "Feb 13 - 12:41 PM",
    "Feb 13 - 12:41 PM",
    "Feb 13 - 12:41 PM",
  ];
  List<String> columnPrice = [
    "150 EGP",
    "150 EGP",
    "150 EGP",
    "150 EGP",
    "150 EGP",
    "150 EGP",
    "150 EGP",
    "150 EGP",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Label(text: LocaleKeys.upcoming.localize,
          //   style: const TextStyle(
          //     fontWeight: FontWeight.w600,
          //     fontSize: 16,
          //   ),
          // ),
          // const SizedBox(height: 16,),
          // Container(
          //   height: 116,
          //   decoration: BoxDecoration(
          //     color: AppColors.whiteColor,
          //     borderRadius: BorderRadius.circular(15),
          //     border: Border.all(
          //       width: 1,
          //       color: AppColors.cF7F7F7,
          //     ),
          //     boxShadow: [
          //       BoxShadow(
          //         color: AppColors.black.withOpacity(0.25),
          //         offset: const Offset(0, 4),
          //         blurRadius: 4,
          //       ),
          //     ],
          //   ),
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          //     child: Row(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Expanded(child:  Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Label(
          //               text: LocaleKeys.youHaveNoUpcomingTrips.localize,
          //               style: const TextStyle(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 20,
          //               ),
          //               maxLines: 3,
          //             ),
          //             const SizedBox(height: 4,),
          //             Label(
          //               text: LocaleKeys.reserveYourRide.localize,
          //               style: const TextStyle(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 16,
          //               ),
          //             ),
          //           ],
          //         ),),
          //         Expanded(child:  Align(
          //           alignment: Alignment.centerRight,
          //           child: Image.asset(
          //             Assets.greyCar,
          //             width: 120, // Adjust width as needed
          //             height: 80, // Adjust height as needed
          //             fit: BoxFit.contain, // Ensures proper fitting
          //           ),
          //         ),),
          //       ],
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 24,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Label(text: LocaleKeys.past.localize,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20
                ),
              ),
              // Container(
              //   height: 32,
              //   width: 32,
              //   decoration: const BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: AppColors.cF3F3F3
              //   ),
              //   child: SvgPicture.asset(Assets.filter,
              //     fit: BoxFit.scaleDown,
              //   ),
              // ),
            ],
          ),
          // const SizedBox(height: 16,),

          // Container(
          //   // height: 116,
          //   decoration: BoxDecoration(
          //     color: AppColors.whiteColor,
          //     borderRadius: BorderRadius.circular(15),
          //     border: Border.all(
          //       width: 1,
          //       color: AppColors.cF7F7F7,
          //     ),
          //     boxShadow: [
          //       BoxShadow(
          //         color: AppColors.black.withOpacity(0.25),
          //         offset: const Offset(0, 4),
          //         blurRadius: 4,
          //       ),
          //     ],
          //   ),
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          //     child: Column(
          //       spacing: 2,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         /// Image takes full width
          //         SizedBox(
          //           width: double.infinity,
          //           child: Image.asset(
          //             Assets.map2,
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //         const Label(
          //           text: "142 Street 53",
          //           style: TextStyle(
          //             fontWeight: FontWeight.w600,
          //             fontSize: 18,
          //           ),
          //         ),
          //         const Label(
          //           text: "Feb 13 - 12:41 PM",
          //           style: TextStyle(
          //             fontWeight: FontWeight.w300,
          //             fontSize: 14,
          //           ),
          //         ),
          //         const Label(
          //           text: "150 EGP",
          //           style: TextStyle(
          //             fontWeight: FontWeight.w600,
          //             fontSize: 14,
          //           ),
          //         ),
          //         const SizedBox(height: 6,),
          //         const Align(
          //           alignment: Alignment.centerLeft,
          //           child: RebookWidget(),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: images.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarContainer(title: titles[index], image: images[index]),
                      const SizedBox(
                        width: 16,
                      ),
                      PriceColumn(title: columnTitle[index], date: columnDate[index],price: columnPrice[index]),
                      const Spacer(),
                      const RebookWidget(),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}

