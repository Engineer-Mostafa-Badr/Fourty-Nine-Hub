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
import '../../../../../../../common/widgets/stateless/buttons/app_button.dart';
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
import '../../../../domain/entities/my_ads_trip_join_entity.dart';
import '../../../cubits/view_all_trip_join_cubit/view_all_trip_join_cubit.dart';
import '../../Modified_widgets/cards/available_trips_card.dart';
import '../../Modified_widgets/trip_join_card.dart';
import '../../Modified_widgets/trip_join_dialog/dialog_content.dart';
import '../../Modified_widgets/trip_join_dialog/show_dialog_trip_join.dart';
import '../../Modified_widgets/trip_join_floating_action_button.dart';
import 'request_log_widget.dart';

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
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.whiteColor,
      backgroundColor: AppColors.PRIMARY_COLOR,
      onRefresh: () async {
        context.read<ViewAllTripJoinCubit>().loadInitialMyAds();
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
            if (context.read<ViewAllTripJoinCubit>().isLoadingMyAds == true) {
              return const Center(
                child: CustomLoadingSearchWidget(),
              );
            }

            if (context.read<ViewAllTripJoinCubit>().myAdsData.isEmpty) {
              return Center(child: CustomEmptyWidget(label:LocaleKeys.youHaveNoAds.localize));
            }

            return OlxPaginationWidget(
              scrollController: _scrollController,
              itemsPerPage: 3,
              loadPage: (page) async {
                context.read<ViewAllTripJoinCubit>().getMyAds();
              },
              banners: bannersList,
              items: List.generate(
                context.read<ViewAllTripJoinCubit>().myAdsData.length,
                    (index) {
                  MyAdsTripDocEntity data =
                  context.read<ViewAllTripJoinCubit>().myAdsData[index];
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
                                      ),
                                      Text(
                                        data.formattedOfferType,
                                        style: Styles.headerText(
                                            color:
                                            AppColors.getRedColor(context),
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
                                    price: formatPrice(
                                        data.pricePerSeat?.round() ?? 1,
                                        context),
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
                                        formatTimestamp(
                                            data.startDate!, context),
                                        style: Styles.headerText(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        // data.passengers == 1
                                        //     ? '${data.passengers} ${LocaleKeys.seat.localize}'
                                        //     : ''
                                        '${formatPrice(
                                            (data.passengers??1).round(),
                                            context)} ${LocaleKeys.seat.localize}',
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
                                      ManageVibration.vibrate();
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
                    text:seats,
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
