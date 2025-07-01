import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_floating_action_button.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../../res/assets/assets.dart';
import '../../../../../../../res/style/app_colors.dart';
import '../../../../../../../res/style/styles.dart';
import '../../../../../../RideFeature/presentation/pages/loading_dashboard/loading_dashboard_details_screen.dart';
import '../../../../domain/entities/request_trip_join_entity.dart';
import '../../../cubits/view_all_trip_join_cubit/view_all_trip_join_cubit.dart';
import '../../Modified_widgets/cards/available_trips_card.dart';
import '../../Modified_widgets/cards/trip_contacts_buttons.dart';
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
  late ScrollController _scrollController;

  bool _isVisible = true;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_scrollListener);
    _scrollController = ScrollController()..addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<ViewAllTripJoinCubit>().getRequestTripJoin();
    }
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_isVisible) {
        setState(() => _isVisible = false);
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_isVisible) {
        setState(() => _isVisible = true);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

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


  // String formatDateTime(DateTime? dateTime) {
  //   if (dateTime == null) return 'No date';
  //
  //   String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
  //   String formattedTime = DateFormat('h:mm a').format(dateTime);
  //
  //   return "$formattedDate\n$formattedTime";
  // }




  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<ViewAllTripJoinCubit, ViewAllTripJoinState>(
          builder: (context, state) {
        if(context.read<ViewAllTripJoinCubit>().isLoadingRequestTripJoin==true){
          return const Center(child: CircularProgressIndicator(),);
        }

        if(context.read<ViewAllTripJoinCubit>().requestTripJoinData.isEmpty){
          return  Center(child: Text(LocaleKeys.noData.localize));
        }
        return ListView.separated(
            controller: _scrollController,
            itemBuilder: (context,i) {
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
                          : (context.isDarkMode ?AppColors.grey : AppColors.grey.shade300),

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
                                     Icon(
                                      Icons.remove_red_eye_sharp,
                                      color: context.isDarkMode ? AppColors.whiteColor:AppColors.DARK_GRAY_COLOR  ,
                                    ),
                                    const Sizer(),
                                    Label(
                                      // text: '${formatViews( 100, context)} ${LocaleKeys.views.localize}',
                                      text: '${formatPrice(formatViews(data.views ?? 0, context).toInt,context)} ${LocaleKeys.views.localize}',
                                      style: Styles.mediumText(
                                        fontSize: 24,
                                        color: context.isDarkMode ? AppColors.whiteColor: AppColors.DARK_GRAY_COLOR,
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
                            price: "${formatPrice(data.pricePerSeat?.round() ?? 10,context)}",
                            title: data.firstName ?? "",
                            icon: data.gender == "male"
                        ? Assets.maleUser
                            : Assets.femaleUser,
                            seats: "${LocaleKeys.eachSeat.localize}"
                            // icon:   Assets.maleUser,
                            //
                            // // : Assets.femaleUser,
                            // seats: "1"
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
                                formatTimestamp12(data.createdAt!,context),
                                style: Styles.headerText(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),

                              Text(
                                // data.trip.passengers == 1
                                //     ? '${data.trip.passengers} ${LocaleKeys.seat.localize}'
                                //     :
                                // '${data.passengers} ${LocaleKeys.seat.localize}',
                                "${formatPrice(data.totalPassengers ?? 1, context)}  ${LocaleKeys.seat.localize}",

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
                          child:ContactsTripButtons(
                            // isPremium: false,
                            isPremium:data.isPremium == true || data.isButtonEnabled!.state == true ? true : false,
                            otherUserId: '2',
                            subcategoryId: '2',
                            phone:data.phoneNumber ?? "123",
                            id: '2',
                            hasReport: true,
                          ),
                          // TripJoinButtonsSection(
                          //   isContactInfo: data.isPremium == true || data.isButtonEnabled!.state == true ? true : false,
                          //   isRequestButton: false,
                          //   buttonTitle:LocaleKeys.requests.localize,
                          //   // buttonTitle:" widget.buttonTitle",
                          //   onTap: (){},
                          // ),
                        ),
                        const Sizer(),
                      ],
                    ),
                  ),
                ],
              ),
              data.isPremium == true || data.isButtonEnabled!.state == true ? SizedBox() : TripCardSubscribeText()   ,

            ],
          ),
        );
        }, separatorBuilder: (context,i)=>SizedBox(height: 10.h,), itemCount: context.read<ViewAllTripJoinCubit>().requestTripJoinData.length);
          },
        ),

        PositionedDirectional(
          bottom: 0.h,
          start: 0,
          end: 0,
          child: AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              offset: _isVisible ? Offset.zero : const Offset(0, 2),
              child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _isVisible ? 1 : 0,
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 30.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.pop();
                            },
                            child: Container(
                              height: 48.h,
                              width: 48.h,
                              decoration: BoxDecoration(
                                  color: AppColors.getButtonPrimaryColor(context),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(
                                size: 19,
                                Icons.question_mark,
                                color: context.isDarkMode?AppColors.black:Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            key: const ValueKey(1),
                            child: TripJoinFloatingActionButton(
                              title: context.isArabic ? "أعلن عن سيارتك" : "Advertise your car",
                              onTap: () {
                                context.push(Routes.TRIP_JOIN);
                              },
                            ),
                          ),
                        ],
                      )))),
        )
      ],
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
                        text: "${price}  ",
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





String convertToArabicNumerals(String input) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  for (int i = 0; i < english.length; i++) {
    input = input.replaceAll(english[i], arabic[i]);
  }
  return input;
}
String formatTimestamp1(dynamic time, BuildContext context) {
  DateTime? date;

  print("formatTimestamp received: $time of type ${time.runtimeType}");

  if (time == null) return "-";

  if (time is String) {
    try {
      date = DateTime.parse(time).toLocal();
    } catch (e) {
      print("Date parsing error: $e");
      return "-";
    }
  } else if (time is int) {
    try {
      if (time.toString().length == 10) {
        date = DateTime.fromMillisecondsSinceEpoch(time * 1000).toLocal();
      } else if (time.toString().length == 13) {
        date = DateTime.fromMillisecondsSinceEpoch(time).toLocal();
      } else {
        print("Unexpected int length: ${time.toString().length}");
        return "-";
      }
    } catch (e) {
      print("Int date parsing error: $e");
      return "-";
    }
  } else {
    print("Unsupported time type");
    return "-";
  }

  if (date == null) return "-";

  final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
  final ampm = date.hour >= 12 ? "PM" : "AM";

  String formattedDate =
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  String formattedTime =
      "${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $ampm";

  String result = "$formattedDate\n  $formattedTime";

  try {
    if (context.locale.languageCode == 'ar') {
      result = convertToArabicNumerals(result)
          .replaceAll("AM", "ص")
          .replaceAll("PM", "م");
    }
  } catch (e) {
    print("Locale check failed: $e");
  }

  return result;
}

String formatTimestamp12(String timestamp, BuildContext context) {
  try {
    DateTime dateTime = DateTime.parse(timestamp);
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.isNegative) {
      return LocaleKeys.justNow.localize;
    }

    int seconds = difference.inSeconds;
    int minutes = difference.inMinutes;
    int hours = difference.inHours;
    int days = difference.inDays;
    int weeks = (days / 7).floor();

    if (seconds < 60) {
      return LocaleKeys.justNow.localize;
    } else if (minutes < 60) {
      return _localizedTime(context.isArabic, minutes, LocaleKeys.minute.localize,context);
    } else if (hours < 24) {
      return _localizedTime(context.isArabic, hours, LocaleKeys.hour.localize,context);
    } else if (days < 7) {
      return _localizedTime(context.isArabic, days, LocaleKeys.day.localize,context);
    } else {
      return _localizedTime(context.isArabic, weeks, LocaleKeys.week.localize,context);
    }
  } catch (e) {
    return "Invalid date";
  }
}

String _localizedTime(bool isArabic, int value, String unit,BuildContext context) {
  if (isArabic) {
    return "منذ ${formatPrice(value, context)} $unit";
  } else {
    return "${formatPrice(value, context)} $unit ago";
  }
}


/*
String formatTimestamp12(String timestamp, BuildContext context) {
  try {
    // Parse the ISO 8601 timestamp
    DateTime dateTime = DateTime.parse(timestamp);

    // Get current time
    DateTime now = DateTime.now();

    // Calculate the difference
    Duration difference = now.difference(dateTime);

    // Handle future dates (just in case)
    if (difference.isNegative) {
      return LocaleKeys.justNow.localize;
    }

    // Calculate time units
    int seconds = difference.inSeconds;
    int minutes = difference.inMinutes;
    int hours = difference.inHours;
    int days = difference.inDays;

    // Return appropriate format
    if (seconds < 60) {
      return LocaleKeys.justNow.localize;
    } else if (minutes < 60) {
      return "$minutes ${LocaleKeys.minAgo.localize}";
    } else if (hours < 24) {
      return "${formatPrice(hours, context)} ${LocaleKeys.hour.localize}${hours == 1 ? '' : ''} ${LocaleKeys.ago.localize}";
    } else if (days < 7) {
      return "${formatPrice(days, context)} ${LocaleKeys.day.localize}${days == 1 ? '' : ''} ${LocaleKeys.ago.localize}";
    } else {
      int weeks = (days / 7).floor();
      return "$weeks ${LocaleKeys.week.localize}${weeks == 1 ? '' : ''} ${LocaleKeys.ago.localize}";
    }
  } catch (e) {
    // Fallback in case of parsing error
    return "Invalid date";
  }
}
*/


String formatTimestamp(dynamic time, BuildContext context) {
  DateTime? date;

  if (time is String) {
    try {
      date = DateTime.parse(time).toLocal();
    } catch (e) {
      return "-";
    }
  } else if (time is int) {
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

  String formattedDate =
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  String formattedTime =
      "${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $ampm";

  String result = "$formattedDate\n  $formattedTime";

  if (context.locale.languageCode == 'ar') {
    result = convertToArabicNumerals(result)
        .replaceAll("AM", "ص")
        .replaceAll("PM", "م");
  }

  return result;
}

