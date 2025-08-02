import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/loading_dashboard/loading_dashboard_details_screen.dart';

import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../common/widgets/stateless/verified_widget.dart';
import '../../../../../res/style/styles.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../domain/entities/dashboards/get_past_ride_non_socket_trip_entity.dart';
import 'car_circle_widget.dart';
import 'info_column_widget.dart';


class PastNonSocketTripsWidget extends StatefulWidget {
  final HistoryTripEntity ? tripEntity;
  const PastNonSocketTripsWidget(
      {super.key, required  this.tripEntity});

  @override
  State<PastNonSocketTripsWidget> createState() => _PastNonSocketTripsWidgetState();
}

class _PastNonSocketTripsWidgetState extends State<PastNonSocketTripsWidget> {
  @override
  initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(
        widget.tripEntity?.tripDetails?.createdAt ?? '2025-03-11T21:50:21.998Z');
    String formattedDate =
        "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
    String formattedTime =
        "${dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12} ${dateTime.hour < 12 ? 'AM' : 'PM'}";
    return GestureDetector(
      onTap: () {

        // context.push(Routes.rideDashboardDetailsScreen, extra: widget.tripEntity);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child:Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarContainer(
              title: context.isArabic
                  ? widget.tripEntity?.subCategory?.nameAr ?? ''
                  : widget.tripEntity?.subCategory?.nameEn ?? '',
              image: widget.tripEntity!.subCategory!.pictureUrl!,
            ),
            const SizedBox(width: 12),

            // Flexible middle column
            Expanded(
              child: PriceColumnNonSocket(
                status: widget.tripEntity?.tripDetails?.status ?? "",
                title: widget.tripEntity?.tripDetails?.startLocation?.title ?? '',
                date: formatPickupTime(widget.tripEntity?.tripDetails?.pickupTime,context),
                price: formatPrice(widget.tripEntity?.tripDetails?.price?.toInt() ?? 0.0, context),
              ),
            ),

            const SizedBox(width: 8),

            // Profile column
            SizedBox(
              width: 70,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: widget.tripEntity?.clientDetails?.profilePictureUrl == null ||
                              widget.tripEntity!.clientDetails!.profilePictureUrl!.isEmpty
                              ? Image.asset(
                            Assets.maleImagePlaceholder,
                            fit: BoxFit.cover,
                          )
                              : ImageFromInternet(
                            image: widget.tripEntity!.clientDetails!.profilePictureUrl!,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.cF5F5F5,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Row(
                              children: [
                                SvgPicture.asset(Assets.star2, width: 8, height: 8),
                                const Sizer(width: 4),
                                Label(
                                  text:formatPrice(widget.tripEntity?.clientDetails?.rating?.count ?? 0,context) ,
                                  style: Styles.smallText(color: AppColors.PRIMARY_COLOR),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const VerifiedWidget(),

                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.tripEntity?.clientDetails?.firstName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),

      ),
    );
  }
}
