import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../booking_confirmation/custom_booking_info_row.dart';

class BookingSummaryInfo extends StatelessWidget {
  const BookingSummaryInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Time Row
         CustomBookingInfoRow(
                  context: context,
                  icon: Icons.calendar_today_outlined,
                  title: "02:00 PM : 11:55 PM",
           bgColor: AppColors.whiteColor,
           isBordered: true,

         ),


        const Sizer(height: 12),

       /// Location
        CustomBookingInfoRow(
          context: context,
          icon: Icons.location_pin,
          title: "Nasr city, Cairo",
          bgColor: AppColors.whiteColor,
          isBordered: true,
        ),

        const Sizer(height: 12),

        /// Payment Row
         CustomBookingInfoRow(
                  context: context,
                  icon: Icons.attach_money,
                  title:  "Cash at the Clinic",
           bgColor: AppColors.whiteColor,
           isBordered: true,fees: "100 EGP ",

         ),

      ],
    ) ;
  }
}
