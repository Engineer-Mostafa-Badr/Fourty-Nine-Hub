import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/custom_color_circle_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../domain/entities/dashboards/trip_entity.dart';
import 'widgets/problem_and_client_details.dart';
import 'widgets/ride_details_rating_widget.dart';

class RideDashboardDetailsScreen extends StatefulWidget {
  final TripEntity tripEntity;
  const RideDashboardDetailsScreen({super.key, required this.tripEntity});

  @override
  State<RideDashboardDetailsScreen> createState() =>
      _RideDashboardDetailsScreenState();
}

class _RideDashboardDetailsScreenState
    extends State<RideDashboardDetailsScreen> {
  bool isYourRate = false;
  double yourRate = 3.0;
  bool isClientRate = true;
  double clientRate = 4.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          leadingWidth: 30,
          title: Label(
              text: widget.tripEntity.modeType == 'ride'
                  ? LocaleKeys.rideDetails.tr()
                  : widget.tripEntity.modeType == 'truk'
                      ? LocaleKeys.trukDetails.tr()
                      : LocaleKeys.busDetails.tr(),
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
                                text: widget.tripEntity.modeType == 'ride'
                                    ? LocaleKeys.captainWithYou.tr()
                                    : widget.tripEntity.modeType == 'truk'
                                        ? LocaleKeys.trukWithYou
                                            .tr() //"Truk ride with You"
                                        : LocaleKeys.busWithYou
                                            .tr(), //"Bus ride with You",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 20),
                                maxLines: 3),
                            const SizedBox(height: 8),
                            const Label(
                              text: "Feb 13 - 12:41 PM",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
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
              if (widget.tripEntity.modeType != 'ride')
                Label(
                    text: widget.tripEntity.modeType == 'bus'
                        ? "${LocaleKeys.passenger.tr()} : 10"
                        : "${LocaleKeys.cargoDescription.tr()} : Car",
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
                          text: widget.tripEntity.tripDetails!.startLocation.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Label(
                    text: "12:10 PM",
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
                          text: widget.tripEntity.tripDetails!.targetLocation.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Label(
                    text: "12:10 PM",
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
