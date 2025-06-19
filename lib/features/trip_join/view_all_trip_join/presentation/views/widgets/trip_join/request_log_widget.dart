import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

import '../../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../../res/assets/assets.dart';
import '../../../../../../../res/style/app_colors.dart';
import '../../../../../../../res/style/styles.dart';
import '../../../../domain/entities/request_trip_join_entity.dart';
import '../../../cubits/view_all_trip_join_cubit/view_all_trip_join_cubit.dart';
import '../../Modified_widgets/cards/available_trips_card.dart';
import '../../Modified_widgets/trip_join_card.dart';
import '../../Modified_widgets/trip_join_card_bottom_section.dart';
import '../../Modified_widgets/trip_join_dialog/dialog_content.dart';
import '../../Modified_widgets/trip_join_dialog/show_dialog_trip_join.dart';

class RequestLogTripJoinWidget extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  const RequestLogTripJoinWidget({
    super.key, required this.data,
    required this.fullRequestData,
  });

  final RequestDocsEntity data;
  final RequestTripJoinEntity? fullRequestData;
  @override
  State<RequestLogTripJoinWidget> createState() => _RequestLogTripJoinWidgetState();
}

class _RequestLogTripJoinWidgetState extends State<RequestLogTripJoinWidget> {

  // String formatTimestamp(dynamic time) {
  //   // Handle if time is String
  //   int timestamp = 0;
  //   if (time is String) {
  //     timestamp = int.tryParse(time) ?? 0;
  //   } else if (time is int) {
  //     timestamp = time;
  //   }
  //
  //   if (timestamp == 0) return "-";
  //
  //   DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  //
  //   // Format date to your preferred format (you can customize it)
  //   String formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  //
  //   return formattedDate;
  // }





  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              InkWell(
                onTap: (){
                  context.read<ViewAllTripJoinCubit>().applyReadRequestTrip(widget.data.id);
                },
                child: CustomCard(
                  color: widget.data.read ? AppColors.whiteColor : AppColors.grey.shade300,
                  radius: 20,
                  children: [
                    // Text("${widget.data.read}"),
                    const Sizer(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.0.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.remove_red_eye_sharp,
                                  color: AppColors.DARK_GRAY_COLOR,
                                ),
                                const Sizer(),
                                Label(
                                  text: '${formatViews(widget.data.trip.views ?? 0, context)} ${LocaleKeys.views.localize}',
                                  style: Styles.mediumText(
                                    fontSize: 24,
                                    color: AppColors.DARK_GRAY_COLOR,
                                  ),
                                ),

                              ],
                            ),
                          ),
                          Text(
                            "${widget.data.trip.status ?? ""}",
                            style: Styles.headerText(
                                color: AppColors.getRedColor(context), fontSize: 32),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    TripCardInfoWidget(
                      price: "${widget.data.trip.price}",
                      title: widget.data.userId.firstName,
                      icon: widget.data.userId.gender == "male"
                          ? Assets.maleUser
                          : Assets.femaleUser,
                        seats: "${widget.data.trip.passengers ?? 0}"
                    ),
                    const Sizer(
                      height: 30,
                    ),
                    _locationWidget(
                        title: context.isArabic
                            ? widget.data?.trip.fromAr ?? ""
                            : widget.data?.trip.fromEn ?? "",
                        iconColor: AppColors.LIGHT_BLUE),
                    const Sizer(),
                    _locationWidget(
                        title: context.isArabic
                            ? widget.data?.trip.toAr ?? ""
                            : widget.data?.trip.toEn ?? "",
                        iconColor: AppColors.CHECK_MARK_COLOR),
                    const Sizer(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.0.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatTimestamp(widget.data.trip.time),
                            style: Styles.headerText(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            // widget.data.trip.passengers == 1
                            //     ? '${widget.data.trip.passengers} ${LocaleKeys.seat.localize}'
                            //     :
                            '${widget.data.trip.passengers} ${LocaleKeys.seat.localize}',

                            style: Styles.headerText(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.data.trip.isRepeat ? LocaleKeys.repeated.localize : LocaleKeys.oneTime.localize,
                            // widget.status,
                            style: Styles.headerText(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.0.h,
                      ),
                      child: TripJoinButtonsSection(
                        isContactInfo: true,
                        isRequestButton: false,
                        buttonTitle:LocaleKeys.requests.localize,
                        // buttonTitle:" widget.buttonTitle",
                        onTap: (){},
                      ),
                    ),
                    const Sizer(),
                  ],
                ),
              ),
            ],
          ),
          TripCardSubscribeText(),
        ],
      ),
    );
  }

  _locationWidget({required String title, required Color iconColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 32.0.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.trip_origin, color: iconColor, size: 20),
          const Sizer(width: 13),
          Flexible(
            child: Text(
              title,
              style: Styles.headerText(fontSize: 32),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  TripCardInfoWidget({
    required String title,
    required String price,
    required String icon,
    required String seats,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 32.0.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: 48.h,
            fit: BoxFit.cover,
            color: context.isDarkMode&&icon==Assets.tripJoinCarIcon?Colors.white:null,
          ),
          const Sizer(),
          Text(
            title,
            style: Styles.headerText(),
          ),
          Expanded(child: Container()),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: price,
                        style: Styles.headerText(
                            color: AppColors.getTextColor(context),
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: context.isArabic ? 'ج.م' : 'EGP',
                      style: Styles.mediumText(
                          fontSize: context.locale.languageCode == "ar" ? 35 : 28,
                          fontWeight: FontWeight.w500,
                          color: AppColors.getRedColor(context)),
                    )
                  ])),
              Row(
                spacing: 5,
                children: [
                  Label(
                    text: seats,
                    style: Styles.mediumText(
                        fontWeight: FontWeight.bold,
                        color: AppColors.getTextColor(context)),
                  ),
                  Label(
                    text: LocaleKeys.seat.localize,
                    style: Styles.mediumText(
                        fontWeight: FontWeight.bold,
                        color: AppColors.getTextColor(context)),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  TripCardSubscribeText() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.h, 10.h, 20.h, 0),
      child: InkWell(
        onTap: () => showDialogTripJoin(
            context,
            DialogContent(
              subTitle: LocaleKeys.pleaseSubscribeToContactTheClient.localize,
              leftButtonTitle: LocaleKeys.close.localize,
              rightButtonTitle: LocaleKeys.subscribe.localize,
            )),
        child: Text(
          LocaleKeys.subscribeToContactClient.localize,
          style: Styles.headerText(
            color: AppColors.getRedColor(context),
            fontSize: 30,
          ),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}
String formatTimestamp(dynamic time) {
  int timestamp = 0;

  // Parse input whether it's String or int
  if (time is String) {
    timestamp = int.tryParse(time) ?? 0;
  } else if (time is int) {
    timestamp = time;
  }

  if (timestamp == 0) return "-";

  // Convert seconds to milliseconds
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  // Get 12-hour format hour
  int hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
  String ampm = date.hour >= 12 ? "PM" : "AM";

  // Format date and time separately
  String formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  String formattedTime = "${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $ampm";

  // Return with line break between date and time
  return "$formattedDate\n  $formattedTime";
}