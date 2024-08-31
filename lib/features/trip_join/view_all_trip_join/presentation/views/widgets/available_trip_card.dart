import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/trip_join_card_entity.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:intl/intl.dart';

class AvailableTripCard extends StatelessWidget {
  const AvailableTripCard({
    super.key,
    required this.tripJoinCardEntity,
    this.premuimRequestOnTap,
    this.requestOnTap,
    this.callOnTap,
    this.messageOnTap,
    this.reportOnTap,
  });
  final TripJoinCardEntity tripJoinCardEntity;
  final void Function()? premuimRequestOnTap;
  final void Function()? requestOnTap;
  final void Function()? callOnTap;
  final void Function()? messageOnTap;
  final void Function()? reportOnTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CustomCard(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.time_to_leave),
                      const Sizer(),
                      Text(
                        '${tripJoinCardEntity.brand}, ${tripJoinCardEntity.model}',
                        style: Styles.headerText(
                          fontSize: 45,
                          color: AppColors.SECONDARY_COLOR,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  const Sizer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_month),
                      const Sizer(),
                      Text(_formatDate(), style: Styles.headerText()),
                    ],
                  ),
                  const Sizer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.airline_seat_recline_extra_rounded),
                      const Sizer(),
                      Text('${tripJoinCardEntity.seatNumber ?? 1} Seat', style: Styles.headerText()),
                      const Spacer(),
                      Icon(
                        (tripJoinCardEntity.isRepeated ?? false) ? Icons.check_box : Icons.check_box_outline_blank,
                        color: AppColors.PRIMARY_COLOR,
                      ),
                      const Sizer(),
                      Text('Repeated', style: Styles.headerText()),
                      const Sizer(width: 20),
                    ],
                  ),
                  const Sizer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.trip_origin, color: AppColors.LIGHT_BLUE, size: 20),
                      const Sizer(width: 13),
                      Flexible(
                        child: Text(
                          tripJoinCardEntity.startingAddressEn ?? '',
                          style: Styles.headerText(fontSize: 32),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const Sizer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.trip_origin, color: AppColors.CHECK_MARK_COLOR, size: 20),
                      const Sizer(width: 13),
                      Text(
                        tripJoinCardEntity.destinationAddressEn ?? '',
                        style: Styles.headerText(fontSize: 32),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                  const Sizer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: AvaialbleTripsButton(
                          title: 'Premium Request',
                          color: AppColors.SECONDARY_COLOR,
                          onTap: premuimRequestOnTap,
                        ),
                      ),
                      const Sizer(width: 5),
                      Expanded(
                        flex: 3,
                        child: AvaialbleTripsButton(
                          title: 'Request',
                          color: AppColors.PRIMARY_COLOR,
                          onTap: requestOnTap,
                        ),
                      )
                    ],
                  ),
                  const Sizer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: AvaialbleTripsButton(
                          title: 'Call',
                          color: (tripJoinCardEntity.isApproved ?? false)
                              ? AppColors.PRIMARY_COLOR
                              : AppColors.DARK_GRAY_COLOR,
                          icon: Icons.call,
                          onTap: callOnTap,
                        ),
                      ),
                      const Sizer(width: 5),
                      Expanded(
                        flex: 3,
                        child: AvaialbleTripsButton(
                          title: 'Message',
                          color: (tripJoinCardEntity.isApproved ?? false)
                              ? AppColors.PRIMARY_COLOR
                              : AppColors.DARK_GRAY_COLOR,
                          icon: Icons.email,
                          onTap: messageOnTap,
                        ),
                      ),
                      const Sizer(width: 5),
                      Expanded(
                        flex: 3,
                        child: AvaialbleTripsButton(
                          title: 'Report',
                          color: AppColors.SECONDARY_COLOR,
                          icon: Icons.report,
                          onTap: messageOnTap,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 5,
                right: 20,
                child: Column(
                  children: [
                    Text(tripJoinCardEntity.journeyPrice?.toStringAsFixed(0) ?? '',
                        style: Styles.headerText(fontSize: 70, color: Colors.green[600])),
                    Text(tripJoinCardEntity.status ?? '',
                        style: Styles.headerText(fontSize: 30, color: AppColors.SECONDARY_COLOR)),
                  ],
                ),
              )
            ],
          ),
          const Sizer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Subscribe to contact the client!',
              style: Styles.headerText(
                color: Colors.red[300],
                fontSize: 30,
              ),
              textAlign: TextAlign.start,
            ),
          )
        ],
      ),
    );
  }

  String _formatDate() {
    if (tripJoinCardEntity.publishDate == null) {
      return '';
    }
    return DateFormat('dd MMM yyyy hh:mm aaa')
        .format(DateTime.fromMicrosecondsSinceEpoch(tripJoinCardEntity.publishDate!));
  }
}
