import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/card.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/domain/entities/tripjoin_request_entity.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:intl/intl.dart' as intl;

class TripJoinRequestCard extends StatelessWidget {
  const TripJoinRequestCard({
    super.key,
    required this.tripJoinRequestEntity,
    this.requestHistoryOnTap,
    required this.deleteRequestOnTap,
    this.subscribeOnTap,
  });
  final TripJoinMyRequestEntity tripJoinRequestEntity;
  final void Function()? requestHistoryOnTap;
  final void Function() deleteRequestOnTap;
  final void Function()? subscribeOnTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Stack(
        children: [
          CustomCard(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.time_to_leave),
                  const Sizer(),
                  Text(
                    '${tripJoinRequestEntity.brand}, ${tripJoinRequestEntity.model}',
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
                  Text(_formatDate(tripJoinRequestEntity.publishDate),
                      style: Styles.headerText()),
                ],
              ),
              const Sizer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.airline_seat_recline_extra_rounded),
                  const Sizer(),
                  Text('${tripJoinRequestEntity.seatNumber ?? 1} Seat',
                      style: Styles.headerText()),
                  const Spacer(),
                  Visibility(
                    visible: tripJoinRequestEntity.isRepeated ?? false,
                    child: Icon(
                      (tripJoinRequestEntity.isRepeated ?? false)
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: AppColors.PRIMARY_COLOR,
                    ),
                  ),
                  const Sizer(),
                  Visibility(
                    visible: tripJoinRequestEntity.isRepeated ?? false,
                    child: Text('Repeated', style: Styles.headerText()),
                  ),
                  const Sizer(width: 20),
                ],
              ),
              const Sizer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.trip_origin,
                      color: AppColors.LIGHT_BLUE, size: 20),
                  const Sizer(width: 13),
                  Flexible(
                    child: Text(
                      tripJoinRequestEntity.startingAddressEn ?? '',
                      style: Styles.headerText(fontSize: 32),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              const Sizer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.trip_origin,
                      color: AppColors.CHECK_MARK_COLOR, size: 20),
                  const Sizer(width: 13),
                  Flexible(
                    child: Text(
                      tripJoinRequestEntity.destinationAddressEn ?? '',
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
                  Expanded(
                    flex: 1,
                    child: AvaialbleTripsButton(
                      title: 'RequestHistory',
                      color: AppColors.PRIMARY_COLOR,
                      onTap: requestHistoryOnTap,
                    ),
                  ),
                  const Sizer(width: 5),
                  Expanded(
                    flex: 1,
                    child: AvaialbleTripsButton(
                      title: 'Delete',
                      color: AppColors.SECONDARY_COLOR,
                      onTap: () async {
                        await showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              padding: EdgeInsets.only(
                                  top: 30.h,
                                  right: 15.w,
                                  left: 15.w,
                                  bottom: 20.h),
                              child: AreYouSure(
                                title: LocaleKeys.alert.localize,
                                subTitle: LocaleKeys.clearNoti.localize,
                                action: () {
                                  deleteRequestOnTap();
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
              const Sizer(),
              AvaialbleTripsButton(
                title: 'Subscribe',
                color: AppColors.PRIMARY_COLOR,
                onTap: subscribeOnTap,
              ),
              const Sizer(),
              Text(
                'The Subscription will end at ${_formatSubscriptionDate(tripJoinRequestEntity.subscriptionEndDate)}',
                style: Styles.mediumText(color: AppColors.SECONDARY_COLOR),
              )
            ],
          ),
          Positioned.directional(
            top: 5,
            end: 20,
            textDirection:
                context.isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: Column(
              children: [
                Text(
                    tripJoinRequestEntity.journeyPrice?.toStringAsFixed(0) ??
                        '',
                    style: Styles.headerText(
                        fontSize: 70, color: Colors.green[600])),
                Text(tripJoinRequestEntity.status ?? '',
                    style: Styles.headerText(
                        fontSize: 30, color: AppColors.SECONDARY_COLOR)),
              ],
            ),
          )
        ],
      ),
    );
  }

  String _formatDate(int? timestamp) {
    if (timestamp == null) {
      return '';
    }
    return intl.DateFormat('dd MMM, hh:mm aaa')
        .format(DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000000));
  }

  String _formatSubscriptionDate(int? timestamp) {
    if (timestamp == null) {
      return '';
    }
    return intl.DateFormat('yMMMMd')
        .format(DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000000));
  }
}
