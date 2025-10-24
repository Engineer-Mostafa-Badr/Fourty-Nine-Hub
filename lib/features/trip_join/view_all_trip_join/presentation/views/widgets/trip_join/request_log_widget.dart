import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/banner.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/olx_pagination_widget.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/edit_page.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/floating_add_button.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../core/extensions/context_extension.dart';
import '../../../../../../../core/extensions/string_extension.dart';
import '../../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../../core/widget/custom_loading_search_widget.dart';
import '../../../../../../../helpers/manage_vibration.dart';
import '../../../../../../../res/assets/assets.dart';
import '../../../../../../../res/style/app_colors.dart';
import '../../../../../../../res/style/styles.dart';
import '../../../../../../../routes/routes.dart';
import '../../../../../../RideFeature/presentation/pages/loading_dashboard/loading_dashboard_details_screen.dart';
import '../../../../domain/entities/request_trip_join_entity.dart';
import '../../../cubits/view_all_trip_join_cubit/view_all_trip_join_cubit.dart';
import '../../Modified_widgets/cards/available_trips_card.dart';
import '../../Modified_widgets/cards/trip_contacts_buttons.dart';
import '../../Modified_widgets/trip_join_card.dart';
import '../../Modified_widgets/trip_join_dialog/dialog_content.dart';
import '../../Modified_widgets/trip_join_dialog/show_dialog_trip_join.dart';
import '../../Modified_widgets/trip_join_floating_action_button.dart';

String convertToArabicNumerals(String input) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  for (int i = 0; i < english.length; i++) {
    input = input.replaceAll(english[i], arabic[i]);
  }
  return input;
}

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

  final hour =
      date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
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

  final hour =
      date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
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
      return _localizedTime(
          context.isArabic, minutes, LocaleKeys.minute.localize, context);
    } else if (hours < 24) {
      return _localizedTime(
          context.isArabic, hours, LocaleKeys.hour.localize, context);
    } else if (days < 7) {
      return _localizedTime(
          context.isArabic, days, LocaleKeys.day.localize, context);
    } else {
      return _localizedTime(
          context.isArabic, weeks, LocaleKeys.week.localize, context);
    }
  } catch (e) {
    return "Invalid date";
  }
}

String _localizedTime(
    bool isArabic, int value, String unit, BuildContext context) {
  if (isArabic) {
    return "منذ ${formatPrice(value, context)} $unit";
  } else {
    return "${formatPrice(value, context)} $unit ago";
  }
}

class RequestLogTripJoinWidget extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  const RequestLogTripJoinWidget({
    super.key,
  });

  @override
  State<RequestLogTripJoinWidget> createState() =>
      _RequestLogTripJoinWidgetState();
}

class _RequestLogTripJoinWidgetState extends State<RequestLogTripJoinWidget> {
  late ScrollController _scrollController;

  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.whiteColor,
      backgroundColor: AppColors.PRIMARY_COLOR,
      onRefresh: () async {
        context.read<ViewAllTripJoinCubit>().loadInitialRequestTripJoin();
        context.read<ViewAllTripJoinCubit>().getRequestCount();
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: isFloatingButtonVisible
            ? buildFloatingAction(context,child: Padding(
          padding: const EdgeInsetsDirectional.only(start: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  context.push(Routes.tripJoinInfoScreen);
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
                    color: context.isDarkMode
                        ? AppColors.black
                        : Colors.white,
                  ),
                ),
              ),
              CustomElevatedButton(
                  onPressed: () {
                    ManageVibration.vibrate();
                    context.push(Routes.TRIP_JOIN, extra: false);
                  },
                  backgoundColor: AppColors.getButtonPrimaryColor(context),
                  child: Label(
                    text: context.isArabic ? "أعلن عن سيارنك +" : "Advertise your car +",
                    style: Styles.mediumText(
                      fontWeight: FontWeight.bold,
                      color: AppColors.getReversedTextColor(context),
                    ),
                  ))
            ],
          ),
        ), () {
          ManageVibration.vibrate();
          context.push(Routes.TRIP_JOIN, extra: false);
        })
            : null,
        body: BlocBuilder<ViewAllTripJoinCubit, ViewAllTripJoinState>(
          builder: (context, state) {
            if (context.read<ViewAllTripJoinCubit>().isLoadingRequestTripJoin ==
                true) {
              return const Center(
                child: CustomLoadingSearchWidget(),
              );
            }

            if (context
                .read<ViewAllTripJoinCubit>()
                .requestTripJoinData
                .isEmpty) {
              return Center(child: CustomEmptyWidget(label:LocaleKeys.noRequests.localize));
            }
            return OlxPaginationWidget(
              scrollController: _scrollController,
              itemsPerPage: 3,
              loadPage: (page) async {
                context.read<ViewAllTripJoinCubit>().getRequestTripJoin();
              },
              banners: bannersList,
              items: List.generate(
                context
                    .read<ViewAllTripJoinCubit>()
                    .requestTripJoinData.length,
                    (index) {
                  GetRequestTripJoinEntity data = context
                      .read<ViewAllTripJoinCubit>()
                      .requestTripJoinData[index];
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
                              onTap: () {
                                ManageVibration.vibrate();
                                context
                                    .read<ViewAllTripJoinCubit>()
                                    .applyReadRequestTrip(data.id!);
                              },
                              child: CustomCard(
                                // color: data.isRead  == true  ? AppColors.whiteColor : AppColors.grey.shade300,
                                color: data.isRead == true
                                    ? (context.isDarkMode
                                    ? Colors.transparent
                                    : AppColors.whiteColor)
                                    : (context.isDarkMode
                                    ? AppColors.grey
                                    : AppColors.grey.shade300),

                                radius: 20,
                                children: [
                                  // Text("${data.read}"),
                                  const Sizer(),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 32.0.h),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: ClickableWidget(
                                            onTap: () {
                                              if((data.lastViewers?.length??0)>0) {
                                                ManageVibration.vibrate();
                                                showModalBottomSheet(
                                                  backgroundColor: context.isDarkMode
                                                      ? AppColors.DARK_BLUE_COLOR
                                                      .withOpacity(0.95)
                                                      : AppColors.LIGHT_COLOR,
                                                  constraints: BoxConstraints(
                                                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                                                  ),
                                                  context: context,
                                                  shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(32.0),
                                                      topRight: Radius.circular(32.0),
                                                    ),
                                                  ),
                                                  isDismissible: true,
                                                  // isScrollControlled: true,
                                                  builder: (BuildContext context) {
                                                    return Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        children: [
                                                          Text(context.isArabic?'المشاهدون':'Viewers',style: Styles.headerText(color: context.isDarkMode?Colors.white:AppColors.PRIMARY_COLOR),),
                                                          Expanded(
                                                            child: ListView(
                                                              shrinkWrap: true,
                                                              children: List.generate(data.lastViewers?.length??0, (i)=>Container(
                                                                padding: EdgeInsets.only(bottom: 10),
                                                                child: Row(
                                                                  children: [
                                                                    ImageFromInternet(
                                                                        image: '',
                                                                        isCircle: true,
                                                                        defaultLogo: false,
                                                                        isMale: data.lastViewers?[i].gender=='male',
                                                                        width: 40,
                                                                        height: 40,
                                                                        firstChar: data.lastViewers?[i].firstName?[0].toUpperCase(),
                                                                        charPadding: 0),
                                                                    const Sizer(),
                                                                    Text(data.lastViewers?[i].firstName??'',style: Styles.mediumText(color: context.isDarkMode?Colors.white:AppColors.PRIMARY_COLOR),),
                                                                  ],
                                                                ),
                                                              )),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.remove_red_eye_sharp,
                                                  color: context.isDarkMode
                                                      ? AppColors.whiteColor
                                                      : AppColors
                                                      .DARK_GRAY_COLOR,
                                                ),
                                                const Sizer(),
                                                Label(
                                                  // text: '${formatViews( 100, context)} ${LocaleKeys.views.localize}',
                                                  text:
                                                  '${formatPrice(formatViews(data.views ?? 0, context).toInt, context)} ${LocaleKeys.views.localize}',
                                                  style: Styles.mediumText(
                                                    fontSize: 24,
                                                    color: context.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors
                                                        .DARK_GRAY_COLOR,
                                                  ),
                                                ),
                                              ],
                                            ),
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
                                    price: formatPrice(
                                        data.pricePerSeat?.round() ?? 10,
                                        context),
                                    title: data.firstName ?? "",
                                    icon: data.gender == "male"
                                        ? Assets.maleUser
                                        : Assets.femaleUser,
                                    seats: LocaleKeys.eachSeat.localize,
                                    isMale: data.gender == "male",
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
                                      data.location?.start?.address ?? "",
                                      iconColor: AppColors.LIGHT_BLUE),
                                  const Sizer(),
                                  _locationWidget(
                                      title: data.location?.target?.address ??
                                          "",
                                      iconColor: AppColors.CHECK_MARK_COLOR),
                                  const Sizer(),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 32.0.h,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          formatTimestamp12(
                                              data.createdAt!, context),
                                          style: Styles.headerText(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          // data.trip.passengers == 1
                                          //     ? '${data.trip.passengers} ${LocaleKeys.seat.localize}'
                                          //     :
                                          // '${data.passengers} ${LocaleKeys.seat.localize}',
                                          "${formatPrice(data.totalPassengers ?? 1, context)}  ${LocaleKeys.seat.localize}",

                                          style: Styles.headerText(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          // data.isRepeat ? LocaleKeys.repeated.localize :
                                          LocaleKeys.oneTime.localize,
                                          // widget.status,
                                          style: Styles.headerText(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 32.0.h,
                                    ),
                                    child: ContactsTripButtons(
                                      // isPremium: false,
                                      subscriptionTitle:LocaleKeys.tripJoin.localize,
                                      isPremium: data.isPremium == true ||
                                          data.isButtonEnabled!.state ==
                                              true
                                          ? true
                                          : false,
                                      otherUserId: '2',
                                      subcategoryId: '2',
                                      phone: data.phoneNumber ?? "123",
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
                        data.isPremium == true ||
                            data.isButtonEnabled!.state == true
                            ? SizedBox()
                            : TripCardSubscribeText(),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  TripCardInfoWidget({
    required String title,
    required String price,
    required String icon,
    required String seats,
    required bool isMale,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 32.0.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageFromInternet(
            image: icon,
            height: 48.h,
            width: 48.h,
            isCircle: true,
            border: Border.all(color: AppColors.getButtonPrimaryColor(context)),
            firstChar: title[0].toUpperCase(),
            charPadding: 0,
            isMale: isMale,
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
                    text: "$price  ",
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

  _locationWidget({required String title, required Color iconColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 32.0.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.trip_origin, color: iconColor, size: 14),
          const Sizer(width: 13),
          Flexible(
            child: Text(
              title,
              style: Styles.headerText(fontSize: 26),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }


  bool isFloatingButtonVisible = true;
  void _scrollListener() {

    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      isFloatingButtonVisible = false;
    } else {
      isFloatingButtonVisible = true;
    }
    setState((){});
    }
}
