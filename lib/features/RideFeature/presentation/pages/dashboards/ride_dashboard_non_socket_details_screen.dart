import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/custom_color_circle_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../domain/entities/dashboards/get_past_ride_non_socket_trip_entity.dart';
import '../../../domain/entities/dashboards/trip_entity.dart';
import 'widgets/problem_and_client_details.dart';
import 'widgets/ride_details_rating_widget.dart';

class RideDashboardNonSocketDetailsScreen extends StatefulWidget {
  const RideDashboardNonSocketDetailsScreen({super.key, required this.tripEntity,});
final HistoryTripEntity tripEntity;
  @override
  State<RideDashboardNonSocketDetailsScreen> createState() =>
      _RideDashboardNonSocketDetailsScreenState();
}

class _RideDashboardNonSocketDetailsScreenState
    extends State<RideDashboardNonSocketDetailsScreen> {
  bool isYourRate = false;
  double yourRate = 3.0;
  bool isClientRate = true;
  double clientRate = 4.0;

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(
        widget.tripEntity?.tripDetails?.createdAt ?? '2025-03-11T21:50:21.998Z');
    String formattedDate =
        "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
    // String formattedTime =
    //     "${dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12} ${dateTime.hour < 12 ? 'AM' : 'PM'}";
    String formattedTime =
        "${(dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12)}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour < 12 ? 'AM' : 'PM'}";

    DateTime dateTimePickUp = DateTime.parse(
        widget.tripEntity?.tripDetails?.pickupTime ?? '2025-03-11T21:50:21.998Z');
    String formattedDatePickUp =
        "${dateTimePickUp.day.toString().padLeft(2, '0')}/${dateTimePickUp.month.toString().padLeft(2, '0')}/${dateTimePickUp.year}";
    // String formattedTimePickUp =
    //     "${dateTimePickUp.hour % 12 == 0 ? 12 : dateTimePickUp.hour % 12} ${dateTimePickUp.hour < 12 ? 'AM' : 'PM'}";
    String formattedTimePickUp =
        "${(dateTimePickUp.hour % 12 == 0 ? 12 : dateTimePickUp.hour % 12)}:${dateTimePickUp.minute.toString().padLeft(2, '0')} ${dateTimePickUp.hour < 12 ? 'AM' : 'PM'}";

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          leadingWidth: 30,
          title: Label(
              text:
                  LocaleKeys.rideDetails.tr(),

              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 20))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                          spacing: 2,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Label(
                                text:( context.isArabic ? widget.tripEntity.subCategory?.nameAr  :  widget.tripEntity.subCategory?.nameEn ) ?? LocaleKeys.captainWithYou.tr() ,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 20),
                                maxLines: 3),
                            const SizedBox(height: 8),
                            Row(
                              spacing: 5,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Label(
                                  text: formattedDate, //'20/2/2025',
                                  style: Styles.mediumText(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text("-", style: Styles.mediumText(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 50.sp
                                ),),
                                Label(
                                  text: formattedTime, //'10 AM',
                                  style: Styles.mediumText(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Label(
                                text: "${widget.tripEntity.tripDetails!.price} ${LocaleKeys.egp.tr()}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16)),
                          ]),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Image.asset(
                          Assets.greyCar,
                          width: 80,
                          height: 33,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // if (widget.tripEntity.modeType != 'ride')
                Label(
                    text: "${LocaleKeys.passenger.tr()} : ${widget.tripEntity.tripDetails?.passengers ?? 0}"
                      ,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16)),
               Row(
                spacing: 18,
                children: [
                  const CustomColorCircleWidget(
                    firstColor: AppColors.c19D176,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Label(
                        //   text: "Cairo International Airport",
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.w600,
                        //     fontSize: 14,
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 2,
                        // ),
                        Label(
                          text: widget.tripEntity.tripDetails?.startLocation?.title ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                   Label(
                    text: formattedTime,
                    style: TextStyle(
                        color: AppColors.c5A5A5A,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
               Row(
                spacing: 18,
                children: [
                  const CustomColorCircleWidget(
                    firstColor: AppColors.c3897F0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Label(
                        //   text: "Cairo International Airport",
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.w600,
                        //     fontSize: 14,
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 2,
                        // ),
                        Label(
                          text: widget.tripEntity.tripDetails?.targetLocation?.title ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                   Label(
                    text: formattedTimePickUp,
                    style: TextStyle(
                        color: AppColors.c5A5A5A,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              RideDetailsRatingWidget(
                  isRate: isYourRate,
                  rate: yourRate,
                  title: LocaleKeys.youRateClient.tr()),
              RideDetailsRatingWidget(
                  isRate: isClientRate,
                  rate: clientRate,
                  title: LocaleKeys.clientRateYou.tr()),
              const ProblemAndClientDetails()
            ],
          ),
        ),
      ),
    );
  }
}
