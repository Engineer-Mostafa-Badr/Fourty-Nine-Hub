import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/running_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_arrived_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_status_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/location_info_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/localization/locale_keys.g.dart';

class BuildGoToClientSheet extends StatelessWidget {
  const BuildGoToClientSheet({super.key, this.onGoingToClient, this.activeTrip});
  final GestureTapCallback? onGoingToClient;
  final RunningTripEntity? activeTrip;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.2,
      maxChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ActionButtonsWidget(
                    driverImageUrl: activeTrip?.clientPicture??'',
                    driverRating: 12.2,
                    driverName: activeTrip?.clientName??'',
                    onContactDriver: () {
                      context.push(Routes.ratingDriverScreen);
                    },
                    onSafety: () {
                      context.push(Routes.ratingClientScreen);
                    },
                    is_show_message: true,
                    onMessage: () {
                      context.push(Routes.completeRideScreen);
                    },
                  ),

                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.PRIMARY_COLOR)
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
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.PRIMARY_COLOR,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.PRIMARY_COLOR)
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
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline,
                              color: Colors.black54),
                          SizedBox(width: 5),
                          Text(
                            "Travel time: ~${(activeTrip?.duration??0)/60} min. Distance: ${((activeTrip?.distance??0) / 1000).toStringAsFixed(1)} ${LocaleKeys.KM.tr()}.",
                            style: TextStyle(
                                color: Colors.black54, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClickableWidget(
                    onTap: onGoingToClient,
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppColors.PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.PRIMARY_COLOR)
                      ),
                      child: Text(
                        context.isArabic ? "الذهاب إلى العميل" : "Go To The Client",
                        style: const TextStyle(
                          fontSize: FontSize.s16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      LocaleKeys.cancelTheRide.localize,
                      style: const TextStyle(
                        fontSize: FontSize.s16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.SECONDARY_COLOR,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
