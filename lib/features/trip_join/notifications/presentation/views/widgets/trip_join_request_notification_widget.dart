import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/trip_join_card_entity.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:intl/intl.dart';

class TripJoinRequestNotificationWidget extends StatelessWidget {
  const TripJoinRequestNotificationWidget({
    super.key,
    required this.tripJoinCardEntity,
    this.callOnTap,
    this.messageOnTap,
    this.reportOnTap,
    this.subscribeCallback,
    this.navigateToRequestHistoryCallback,
  });

  final TripJoinCardEntity tripJoinCardEntity;
  final void Function()? callOnTap;
  final void Function()? messageOnTap;
  final void Function()? reportOnTap;
  final void Function()? subscribeCallback;
  final void Function()? navigateToRequestHistoryCallback;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150.w,
                height: 150.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.grey[300]!, offset: const Offset(3, 3)),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  tripJoinCardEntity.gender == 'female' ? Assets.femaleImagePlacehlder : Assets.maleImagePlaceholder,
                  fit: BoxFit.cover,
                ),
              ),
              Sizer(width: 20.w),
              Text(tripJoinCardEntity.requestOwnerFirstName ?? 'Unknown', style: Styles.headerText()),
              const Spacer(),
              Column(
                children: [
                  Text(
                    tripJoinCardEntity.journeyPrice?.toStringAsFixed(0) ?? '',
                    style: Styles.headerText(fontSize: 70, color: Colors.green[600]),
                  ),
                  Text(
                    _localizeStatus(context, tripJoinCardEntity.status ?? ''),
                    style: Styles.headerText(fontSize: 30, color: AppColors.getSecondryColor(context)),
                  ),
                ],
              )
            ],
          ),
          const Sizer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.time_to_leave),
              const Sizer(),
              Text(
                '${tripJoinCardEntity.brand}, ${tripJoinCardEntity.model}',
                style: Styles.headerText(
                  fontSize: 45,
                  color: AppColors.getSecondryColor(context),
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
              Text(_formatDate(tripJoinCardEntity.publishDate ?? 0), style: Styles.headerText()),
            ],
          ),
          const Sizer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.airline_seat_recline_extra_rounded),
              const Sizer(),
              Text(' ${tripJoinCardEntity.seatNumber ?? 1} ', style: Styles.headerText()),
              Text(LocaleKeys.seat.localize, style: Styles.headerText()),
              const Spacer(),
              Visibility(
                visible: tripJoinCardEntity.isRepeated ?? false,
                child: Icon(
                  (tripJoinCardEntity.isRepeated ?? false) ? Icons.check_box : Icons.check_box_outline_blank,
                  color: AppColors.PRIMARY_COLOR,
                ),
              ),
              const Sizer(),
              Visibility(
                visible: tripJoinCardEntity.isRepeated ?? false,
                child: Text(LocaleKeys.repeat.localize, style: Styles.headerText()),
              ),
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
                  context.isArabic
                      ? tripJoinCardEntity.startingAddressAr ?? ''
                      : tripJoinCardEntity.startingAddressEn ?? '',
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
              Flexible(
                child: Text(
                  context.isArabic
                      ? tripJoinCardEntity.destinationAddressAr ?? ''
                      : tripJoinCardEntity.destinationAddressEn ?? '',
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
                flex: 3,
                child: AvaialbleTripsButton(
                  title: LocaleKeys.call.localize,
                  color: (tripJoinCardEntity.isApproved ?? false) ? AppColors.PRIMARY_COLOR : AppColors.DARK_GRAY_COLOR,
                  icon: Icons.call,
                  onTap: callOnTap,
                ),
              ),
              const Sizer(width: 5),
              Expanded(
                flex: 3,
                child: AvaialbleTripsButton(
                  title: LocaleKeys.message.localize,
                  color: (tripJoinCardEntity.isApproved ?? false) ? AppColors.PRIMARY_COLOR : AppColors.DARK_GRAY_COLOR,
                  icon: Icons.email,
                  onTap: messageOnTap,
                ),
              ),
              const Sizer(width: 5),
              Expanded(
                flex: 3,
                child: AvaialbleTripsButton(
                  title: LocaleKeys.report.localize,
                  color: AppColors.getSecondryColor(context),
                  icon: Icons.report,
                  onTap: reportOnTap,
                ),
              ),
            ],
          ),
          const Sizer(),
          InkWell(
            onTap: subscribeCallback,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                LocaleKeys.subscribeToContactTheClient.localize,
                textAlign: TextAlign.start,
                style: Styles.headerText(color: AppColors.getSecondryColor(context)),
              ),
            ),
          ),
          const Sizer(),
          InkWell(
            onTap: navigateToRequestHistoryCallback,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(LocaleKeys.goToRequestHistory.localize, style: Styles.headerText()),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(int timestamp) {
    return DateFormat('dd MMM, hh:mm aaa', getLang()).format(DateTime.fromMicrosecondsSinceEpoch(timestamp));
  }

  String _localizeStatus(BuildContext context, String text) {
    switch (text.toLowerCase().trim()) {
      case 'regular':
        return context.isArabic ? 'عادي' : 'Regular';
      case 'premium':
        return context.isArabic ? 'مميز' : 'Premium';
      default:
        return text;
    }
  }
}
