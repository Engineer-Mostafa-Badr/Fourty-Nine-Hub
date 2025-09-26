import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/loading_dashboard/loading_dashboard_details_screen.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/request_trip_join_entity.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/cubits/view_all_trip_join_cubit/view_all_trip_join_cubit.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/cards/available_trips_card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/cards/trip_contacts_buttons.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_dialog/dialog_content.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_dialog/show_dialog_trip_join.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_floating_action_button.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/trip_join/request_log_widget.dart';
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

class PickMeRequestLogTripJoinWidget extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  const PickMeRequestLogTripJoinWidget({
    super.key,
  });

  @override
  State<PickMeRequestLogTripJoinWidget> createState() =>
      _PickMeRequestLogTripJoinWidgetState();
}
extension OfferTypeFormatter on GetRequestTripJoinEntity {
  String get formattedOfferType {
    switch (requestType) {
      case 'premium':
        return LocaleKeys.premium2.tr();
      case 'notSubscribed':
        return LocaleKeys.notSubscribed.tr();
      case 'regular':
        return LocaleKeys.regular.tr(); // if you have one
      default:
        return requestType ?? '';
    }
  }
}

class _PickMeRequestLogTripJoinWidgetState extends State<PickMeRequestLogTripJoinWidget> {
  late ScrollController _scrollController;

  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        BlocBuilder<ViewAllTripJoinCubit, ViewAllTripJoinState>(
          builder: (context, state) {
            if (context.read<ViewAllTripJoinCubit>().isLoadingRequestPickMe ==
                true) {
              return const Center(
                child: CustomLoadingSearchWidget(),
              );
            }

            if (context
                .read<ViewAllTripJoinCubit>()
                .requestPickMeData
                .isEmpty) {
              return Center(child: Text(LocaleKeys.noData.localize));
            }
            return GlowingOverscrollIndicator(
              color: AppColors.SECONDARY_COLOR,
              axisDirection: AxisDirection.down,
              child: ListView.separated(
                  controller: _scrollController,
                  itemBuilder: (context, i) {
                    GetRequestTripJoinEntity data = context
                        .read<ViewAllTripJoinCubit>()
                        .requestPickMeData[i];
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
                                      .applyReadRequestPickMe(data.id!);
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
                                          Text(
                                            data.formattedOfferType,
                                            style: Styles.headerText(
                                                color: AppColors.getRedColor(
                                                    context),
                                                fontSize: 32),
                                          ),
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
                          // data.isPremium == true ||
                          //     data.isButtonEnabled?.state == true
                          //     ? SizedBox()
                          //     : TripCardSubscribeText(),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, i) => SizedBox(
                    height: 10.h,
                  ),
                  itemCount: context
                      .read<ViewAllTripJoinCubit>()
                      .requestPickMeData
                      .length),
            );
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
                              ManageVibration.vibrate();
                              context.pop();
                            },
                            child: Container(
                              height: 48.h,
                              width: 48.h,
                              decoration: BoxDecoration(
                                  color:
                                  AppColors.getButtonPrimaryColor(context),
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
                          Container(
                            key: const ValueKey(1),
                            child: TripJoinFloatingActionButton(
                              title: context.isArabic
                                  ? "أعلن عن سيارتك"
                                  : "Advertise your car",
                              onTap: () {
                                ManageVibration.vibrate();
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

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<ViewAllTripJoinCubit>().loadInitialRequestPickMe();

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _scrollController.addListener(_onScroll);
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
  TripCardSubscribeText() async {
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
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ViewAllTripJoinCubit>().getRequestPickMe();
    }
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isVisible) {
        setState(() => _isVisible = false);
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isVisible) {
        setState(() => _isVisible = true);
      }
    }
  }
}
