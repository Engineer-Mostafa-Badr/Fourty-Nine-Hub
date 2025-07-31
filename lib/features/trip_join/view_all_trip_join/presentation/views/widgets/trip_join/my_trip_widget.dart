import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/loading_dashboard/loading_dashboard_details_screen.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_floating_action_button.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/trip_join/request_log_widget.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../../core/widget/custom_loading_search_widget.dart';
import '../../../../../../../res/assets/assets.dart';
import '../../../../../../../res/style/app_colors.dart';
import '../../../../../../../res/style/styles.dart';
import '../../../../domain/entities/my_ads_trip_join_entity.dart';
import '../../../cubits/view_all_trip_join_cubit/view_all_trip_join_cubit.dart';
import '../../Modified_widgets/cards/available_trips_card.dart';
import '../../Modified_widgets/trip_join_card.dart';
import '../../Modified_widgets/trip_join_dialog/dialog_content.dart';
import '../../Modified_widgets/trip_join_dialog/show_dialog_trip_join.dart';

class MyAdsTripWidget extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  const MyAdsTripWidget({super.key});

  @override
  State<MyAdsTripWidget> createState() => _MyAdsTripWidgetState();
}

class _MyAdsTripWidgetState extends State<MyAdsTripWidget> {
  late ScrollController _scrollController;

  bool _isVisible = true;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ViewAllTripJoinCubit>().getMyAds();
    }
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isVisible) {
        print("Visaible $_isVisible");
        setState(() => _isVisible = false);
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isVisible) {
        print("Visaible true $_isVisible");
        setState(() => _isVisible = true);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.removeListener(_scrollListener);

    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<ViewAllTripJoinCubit, ViewAllTripJoinState>(
          builder: (context, state) {
            if (context.read<ViewAllTripJoinCubit>().isLoadingMyAds == true) {
              return const Center(
                child: CustomLoadingSearchWidget(),
              );
            }

            if (context.read<ViewAllTripJoinCubit>().myAdsData.isEmpty) {
              return Center(child: Text(LocaleKeys.noData.localize));
            }

            return ListView.separated(
              shrinkWrap: true,
              controller: _scrollController,
              itemCount: context.read<ViewAllTripJoinCubit>().myAdsData.length,
              separatorBuilder: (context, i) => SizedBox(
                height: 10.h,
              ),
              itemBuilder: (context, i) {
                MyAdsTripDocEntity data =
                    context.read<ViewAllTripJoinCubit>().myAdsData[i];

                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          CustomCard(
                            radius: 20,
                            children: [
                              const Sizer(
                                height: 8,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 32.0.h),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.remove_red_eye_sharp,
                                            color: context.isDarkMode
                                                ? AppColors.whiteColor
                                                : AppColors.DARK_GRAY_COLOR,
                                          ),
                                          const Sizer(),
                                          Label(
                                            text:
                                                '${formatViews(data.views ?? 0, context)} ${LocaleKeys.views.localize}',
                                            style: Styles.mediumText(
                                              fontSize: 24,
                                              color: context.isDarkMode
                                                  ? AppColors.whiteColor
                                                  : AppColors.DARK_GRAY_COLOR,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      data.formattedOfferType,
                                      style: Styles.headerText(
                                          color: AppColors.getRedColor(context),
                                          fontSize: 32),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                              const Sizer(),
                              TripCardInfoWidget(
                                  title: context.isArabic
                                      ? data.vehicleDetails?.brandAr ?? ""
                                      : data.vehicleDetails?.brandEn ?? "",
                                  model: context.isArabic
                                      ? data.vehicleDetails?.modelAr ?? ""
                                      : data.vehicleDetails?.modelEn ?? "",
                                  icon: Assets.tripJoinCarIcon,
                                  price:
                                      formatPrice(data.pricePerSeat?.round() ?? 1, context),
                                  seats: LocaleKeys.eachSeat.localize
                                  // icon: widget.iconCar
                                  //     ? Assets.tripJoinCarIcon
                                  //     : widget.isMale
                                  //     ? Assets.maleUser
                                  //     : Assets.femaleUser,
                                  ),
                              const Sizer(
                                height: 30,
                              ),
                              _locationWidget(
                                  title: data.location?.start?.address ?? "",
                                  iconColor: AppColors.LIGHT_BLUE),
                              const Sizer(),
                              _locationWidget(
                                  title: data.location?.target?.address ?? "",
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
                                      formatTimestamp(data.startDate!, context),
                                      style: Styles.headerText(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      // data.passengers == 1
                                      //     ? '${data.passengers} ${LocaleKeys.seat.localize}'
                                      //     : ''
                                      '${data.passengers} ${LocaleKeys.seat.localize}',
                                      style: Styles.headerText(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      data.isRepeat == true
                                          ? LocaleKeys.repeated.localize
                                          : LocaleKeys.oneTime.localize,
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
                                child: AppButton(
                                  backColor: AppColors.PRIMARY_COLOR_DARK,
                                  color: AppColors.whiteColor,
                                  onPressed: () {
                                    context
                                        .read<ViewAllTripJoinCubit>()
                                        .deleteMyAdsTrip(
                                            data.id ?? "", context);
                                  },
                                  label: LocaleKeys.deleteRequest.localize,
                                ),
                              ),
                              const Sizer(),
                            ],
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
    required String model,
    required String icon,
    required String price,
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
            color: AppColors.getTextColor(context),
          ),
          const Sizer(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: Styles.mediumText(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                Label(
                  text: model,
                  style: Styles.mediumText(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Sizer(),
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
                  // Label(
                  //   text: LocaleKeys.seat.localize,
                  //   style: Styles.mediumText(
                  //       fontWeight: FontWeight.bold,
                  //       color: AppColors.getTextColor(context)),
                  // ),
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

extension OfferTypeFormatter on MyAdsTripDocEntity {
  String get formattedOfferType {
    switch (offerType) {
      case 'premium':
        return LocaleKeys.premium2.tr();
      case 'notSubscribed':
        return LocaleKeys.notSubscribed.tr();
      case 'regular':
        return LocaleKeys.regular.tr(); // if you have one
      default:
        return offerType ?? '';
    }
  }
}
