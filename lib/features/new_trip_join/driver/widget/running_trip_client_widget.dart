import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class RunningTripClientWidget extends StatelessWidget {
  const RunningTripClientWidget({super.key, required this.client, this.index});
  final BookingClientEntity client;
  final int? index;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.transparent,
              child: CircleAvatar(
                backgroundColor: Colors.green,
                radius: 10,
                child: CircleAvatar(
                    backgroundColor: AppColors.getFillColor(context),
                    radius: 5),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                client.location.address,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  color: context.isDarkMode
                      ? Colors.white
                      : AppColors.PRIMARY_COLOR,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  context.isArabic ? "الذهاب الي العميل ${index==0?'الاول':index==1?"الثاني":"الثالث"}" : "Go To ${index==0?'First':index==1?"Second":"Third"} Client",
                  style: const TextStyle(
                    fontSize: FontSize.s16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 25.h,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  context.isArabic ? "افتح خرائط جوجل" : "Open Google Map",
                  style: const TextStyle(
                    fontSize: FontSize.s16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
        Container(
          width: double.infinity,
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.PRIMARY_COLOR),
          ),
          child: Text(
            context.isArabic ? "تقرير العميل" : "Report Client",
            style: const TextStyle(
              fontSize: FontSize.s16,
              fontWeight: FontWeight.bold,
              color: AppColors.PRIMARY_COLOR,
            ),
          ),
        ),
      ],
    );
  }
}
