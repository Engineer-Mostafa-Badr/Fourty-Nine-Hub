import 'package:easy_localization/easy_localization.dart' as EasyLocale;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_card_bottom_section.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_dialog/dialog_content.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_dialog/show_dialog_trip_join.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../domain/entities/available_trip_join_entity.dart';
import '../../../cubits/view_all_trip_join_cubit/view_all_trip_join_cubit.dart';
import '../../widgets/trip_join/request_log_widget.dart';


class AvailableTripsCard extends StatefulWidget {
  const AvailableTripsCard({
    super.key,


  });

  @override
  State<AvailableTripsCard> createState() => _AvailableTripsCardState();
}

class _AvailableTripsCardState extends State<AvailableTripsCard> {

  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_onScroll);
    super.initState();

  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<ViewAllTripJoinCubit>().getTripJoin();

    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewAllTripJoinCubit, ViewAllTripJoinState>(
  builder: (context, state) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: context.read<ViewAllTripJoinCubit>().tripJoinData.length,
          itemBuilder: (context,index){
            var data = context.read<ViewAllTripJoinCubit>().tripJoinData[index];
        return  Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: (){
                  context.read<ViewAllTripJoinCubit>().applyViewTrip(data.id!);
                },
                child: Stack(
                  children: [
                    CustomCard(
                      radius: 20,
                      children: [
                        const Sizer(
                          height: 8,
                        ),
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
                                      text: '${formatViews(data.viewerIds ?? 0, context)} ${LocaleKeys.views.localize}',
                                      style: Styles.mediumText(
                                        fontSize: 24,
                                        color: AppColors.DARK_GRAY_COLOR,
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              Text(
                                "${data.status ?? 0}",
                                style: Styles.headerText(
                                    color: AppColors.getRedColor(context), fontSize: 32),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        const Sizer(),
                        TripCardInfoWidget(
                            title:context.isArabic ?data.vehicleDetails?.brandAr ?? "" : data.vehicleDetails?.brandEn ?? "",
                            model:context.isArabic ?data.vehicleDetails?.modelAr ?? "" :  data.vehicleDetails?.modelEn ?? "",
                            icon: Assets.tripJoinCarIcon,
                            price: "${data.pricePerSeat}",
                            seats: "${data.passengers ?? 0}"
                          // icon: iconCar
                          //     ? Assets.tripJoinCarIcon
                          //     : isMale
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formatTimestamp(data.startDate),
                                style: Styles.headerText(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                // data.passengers == 1
                                //     ? '${data.passengers} ${LocaleKeys.seat.localize}'
                                //     : ''
                                '${data.passengers} ${LocaleKeys.seat.localize}',
                                style: Styles.headerText(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                data.isRepeat  == true ? LocaleKeys.repeated.localize : LocaleKeys.oneTime.localize,
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
                            isRequestButton: true,
                            buttonTitle:LocaleKeys.requests.localize,
                            // buttonTitle:" buttonTitle",
                            onTap: (){},
                          ),
                        ),
                        const Sizer(),
                      ],
                    ),
                  ],
                ),
              ),
              TripCardSubscribeText(),

            ],
          ),
        );
      }),
    );
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
                Label(text:model,
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


String formatViews(num views, BuildContext context) {
  if (views < 1000) {
    return '$views';
  } else if (views < 1000000) {
    double kViews = views / 1000;
    return context.isArabic
        ? '${kViews.toStringAsFixed(1)} ألف' // Arabic style: ألف
        : '${kViews.toStringAsFixed(1)}k';
  } else {
    double mViews = views / 1000000;
    return context.isArabic
        ? '${mViews.toStringAsFixed(1)} مليون' // Arabic style: مليون
        : '${mViews.toStringAsFixed(1)}M';
  }
}

/*
class AvailableTripsCard extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  const AvailableTripsCard({
    super.key,
    required this.time,
    required this.seats,
    required this.status,
    required this.title,
    required this.isMale,
    required this.isContactInfo,
    required this.isRequestButton,
    required this.iconCar,
    required this.buttonTitle,
    required this.onTab,
    required this.subscribtionPlan,
  });

  final String time;
  final int seats;
  final String status;
  final String subscribtionPlan;
  final String title;
  final String buttonTitle;
  final bool isMale;
  final bool isContactInfo;
  final bool isRequestButton;
  final bool iconCar;
  final void Function() onTab;

  @override
  State<AvailableTripsCard> createState() => _AvailableTripsCardState();
}

class _AvailableTripsCardState extends State<AvailableTripsCard> {

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<ViewAllTripJoinCubit>().getTripJoin();

    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewAllTripJoinCubit, ViewAllTripJoinState>(
  builder: (context, state) {
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
                                text:
                                    '437${context.isArabic ? 'الف' : 'k'} ${LocaleKeys.views.localize}',
                                style: Styles.mediumText(
                                    fontSize: 24,
                                    color: AppColors.DARK_GRAY_COLOR),
                              )
                            ],
                          ),
                        ),
                        Text(
                          subscribtionPlan,
                          style: Styles.headerText(
                              color: AppColors.getRedColor(context), fontSize: 32),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  const Sizer(),
                  TripCardInfoWidget(
                    title: title,
                    icon: iconCar
                        ? Assets.tripJoinCarIcon
                        : isMale
                            ? Assets.maleUser
                            : Assets.femaleUser,
                  ),
                  const Sizer(
                    height: 30,
                  ),
                  _locationWidget(
                      title: context.isArabic ? 'الجيزة، مصر' : 'Giza, Egypt',
                      iconColor: AppColors.LIGHT_BLUE),
                  const Sizer(),
                  _locationWidget(
                      title: context.isArabic ? 'الجيزة، مصر' : 'Giza, Egypt',
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
                          time,
                          style: Styles.headerText(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          seats == 1
                              ? '${seats} ${LocaleKeys.seat.localize}'
                              : '${seats} ${LocaleKeys.seat.localize}',
                          style: Styles.headerText(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          status,
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
                      isContactInfo: isContactInfo,
                      isRequestButton: isRequestButton,
                      buttonTitle: buttonTitle,
                      onTap: onTab,
                    ),
                  ),
                  const Sizer(),
                ],
              ),
            ],
          ),
          TripCardSubscribeText(),
        ],
      ),
    );
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
    required String icon,
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
            color:AppColors.getTextColor(context),
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
                    text: '${NumberFormat.decimalPattern('ar').format(20)} ',
                    style: Styles.headerText(
                        color:AppColors.getTextColor(context), fontWeight: FontWeight.bold)),
                TextSpan(
                  text: context.isArabic ? 'ج.م' : 'EGP',
                  style: Styles.mediumText(
                      fontSize: context.locale.languageCode == "ar" ? 35 : 28,
                      fontWeight: FontWeight.w500,
                      color: AppColors.getRedColor(context)),
                )
              ])),
              Label(
                text: LocaleKeys.seat.localize,
                style: Styles.mediumText(
                    fontWeight: FontWeight.bold,
                    color: AppColors.getTextColor(context)),
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
*/

/*
class RequestLogList extends StatelessWidget {
  final ScrollController scrollController;
  const RequestLogList({Key? key, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewAllTripJoinCubit, ViewAllTripJoinState>(
      builder: (context, state) {
        final data = context.read<ViewAllTripJoinCubit>().requestTripJoinData;

        if (data.isEmpty) {
          return Center(child: Text(LocaleKeys.noData.localize));
        }

        return ListView.builder(
          controller: scrollController,
          itemCount: data.length,
          itemBuilder: (context, index) {
            return TripJoinCard(
              subscribtionPlan: LocaleKeys.premium.localize,
              title: context.isArabic ? 'محمد' : 'Mohamed',
              isMale: true,
              buttonTitle: LocaleKeys.request.localize,
              time: context.isArabic ? '8:00 م' : '8:00 Pm',
              seats: 2,
              status: context.isArabic ? 'انتهت' : 'Expired',
              isRequestButton: false,
              isContactInfo: true,
              iconCar: false,
              onTab: () {},
            );
          },
        );
      },
    );
  }
}

class MyAdsList extends StatelessWidget {
  final ScrollController scrollController;
  const MyAdsList({Key? key, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewAllTripJoinCubit, ViewAllTripJoinState>(
      builder: (context, state) {
        final data = context.read<ViewAllTripJoinCubit>().myAdsData;

        if (data.isEmpty) {
          return Center(child: Text(LocaleKeys.noData.localize));
        }

        return ListView.builder(
          controller: scrollController,
          itemCount: data.length,
          itemBuilder: (context, index) {
            return TripJoinCard(
              subscribtionPlan: LocaleKeys.premium.localize,
              title: context.isArabic ? 'كيا، سيراتو' : 'Kia, Cerato',
              isMale: true,
              buttonTitle: LocaleKeys.deleteAd.localize,
              time: context.isArabic ? '8:00 م' : '8:00 Pm',
              seats: 2,
              status: context.isArabic ? 'مرة واحدة' : 'One Time',
              isRequestButton: true,
              isContactInfo: false,
              iconCar: true,
              onTab: () => showDialogTripJoin(
                context,
                DialogContent(
                  subTitle: LocaleKeys.areDeleteThisAd.localize,
                  leftButtonTitle: LocaleKeys.deleteAd.localize,
                  rightButtonTitle: LocaleKeys.close.localize,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

 */