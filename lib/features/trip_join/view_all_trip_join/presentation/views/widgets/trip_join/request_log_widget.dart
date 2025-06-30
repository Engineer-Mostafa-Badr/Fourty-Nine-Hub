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
    super.key,
  });

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


  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'No date';

    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    String formattedTime = DateFormat('h:mm a').format(dateTime);

    return "$formattedDate\n$formattedTime";
  }




  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewAllTripJoinCubit, ViewAllTripJoinState>(
  builder: (context, state) {
    if(context.read<ViewAllTripJoinCubit>().isLoadingRequestTripJoin==true){
      return const Center(child: CircularProgressIndicator(),);
    }

    if(context.read<ViewAllTripJoinCubit>().requestTripJoinData.isEmpty){
      return  Center(child: Text(LocaleKeys.noData.localize));
    }
    return ListView.separated(itemBuilder: (context,i) {
      GetRequestTripJoinEntity data = context.read<ViewAllTripJoinCubit>().requestTripJoinData[i];
      return Padding(
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
                  context.read<ViewAllTripJoinCubit>().applyReadRequestTrip(data.id!);
                },
                child: CustomCard(
                  // color: data.isRead  == true  ? AppColors.whiteColor : AppColors.grey.shade300,
                  color: data.isRead == true
                      ? (context.isDarkMode ? Colors.transparent : AppColors.whiteColor)
                      : (context.isDarkMode ?AppColors.PRIMARY_COLOR_DARK : AppColors.grey.shade300),

                  radius: 20,
                  children: [
                    // Text("${data.read}"),
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
                                  text: '${formatViews( 100, context)} ${LocaleKeys.views.localize}',
                                  style: Styles.mediumText(
                                    fontSize: 24,
                                    color: AppColors.DARK_GRAY_COLOR,
                                  ),
                                ),

                              ],
                            ),
                          ),
                          // Text(
                          //   "${data.status ?? ""}",
                          //   style: Styles.headerText(
                          //       color: AppColors.getRedColor(context), fontSize: 32),
                          // ),
                        ],
                      ),
                    ),
                    const Divider(),
                    TripCardInfoWidget(
                        price: "${data.pricePerSeat}",
                        title: data.firstName ?? "",
                        icon:   Assets.maleUser,

                        // : Assets.femaleUser,
                        seats: "1"
                    ),
                    const Sizer(
                      height: 30,
                    ),
                    _locationWidget(
                        title:
                        data.location?.start?.address ?? ""
                        ,
                        iconColor: AppColors.LIGHT_BLUE),
                    const Sizer(),
                    _locationWidget(
                        title:     data.location?.target?.address ?? "",
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
                            formatDateTime(data.startDate),
                            style: Styles.headerText(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),

                          Text(
                            // data.trip.passengers == 1
                            //     ? '${data.trip.passengers} ${LocaleKeys.seat.localize}'
                            //     :
                            // '${data.passengers} ${LocaleKeys.seat.localize}',
                            "${3}  ${LocaleKeys.seat.localize}",

                            style: Styles.headerText(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            // data.isRepeat ? LocaleKeys.repeated.localize :
                            LocaleKeys.oneTime.localize,
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
    }, separatorBuilder: (context,i)=>SizedBox(height: 10.h,), itemCount: context.read<ViewAllTripJoinCubit>().requestTripJoinData.length);
  },
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


String formatTimestamp2(dynamic time) {
  DateTime? date;

  if (time is String) {
    try {
      // Parse the string and ensure UTC handling with toLocal()
      date = DateTime.parse(time).toLocal();
    } catch (e) {
      print('Error parsing string timestamp: $e'); // Debug log
      return "-";
    }
  } else if (time is int) {
    try {
      if (time.toString().length == 10) {
        // Handle seconds-based timestamp
        date = DateTime.fromMillisecondsSinceEpoch(time * 1000).toLocal();
      } else if (time.toString().length == 13) {
        // Handle milliseconds-based timestamp
        date = DateTime.fromMillisecondsSinceEpoch(time).toLocal();
      } else {
        print('Invalid integer timestamp length: $time'); // Debug log
        return "-";
      }
    } catch (e) {
      print('Error parsing integer timestamp: $e'); // Debug log
      return "-";
    }
  } else {
    print('Invalid timestamp type: $time'); // Debug log
    return "-";
  }

  // Ensure date is not null before formatting
  if (date == null) {
    print('Date is null'); // Debug log
    return "-";
  }

  // Format hour for 12-hour clock
  final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
  final ampm = date.hour >= 12 ? "PM" : "AM";

  // Format date and time
  final formattedDate =
      "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  final formattedTime =
      "${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $ampm";

  return "$formattedDate\n$formattedTime";
}

String formatTimestamp(dynamic time) {
  DateTime? date;

  if (time is String) {
    try {
      date = DateTime.parse(time).toLocal(); // Convert from UTC to local time
    } catch (e) {
      return "-";
    }
  } else if (time is int) {
    // If it's a timestamp in seconds or milliseconds
    if (time.toString().length == 10) {
      date = DateTime.fromMillisecondsSinceEpoch(time * 1000).toLocal();
    } else if (time.toString().length == 13) {
      date = DateTime.fromMillisecondsSinceEpoch(time).toLocal();
    } else {
      return "-";
    }
  } else {
    return "-";
  }

  final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
  final ampm = date.hour >= 12 ? "PM" : "AM";

  final formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  final formattedTime = "${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $ampm";

  return "$formattedDate\n  $formattedTime";
}
