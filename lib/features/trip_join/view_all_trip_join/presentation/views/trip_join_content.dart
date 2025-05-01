import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/cards/available_trips_card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/cards/display_trip_join_card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_bottom_sheet/show_bottom_sheet.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_bottom_sheet/submit_bottom_sheet.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_dialog/dialog_content.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_dialog/show_dialog_trip_join.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TripJoinContent extends StatefulWidget {
  const TripJoinContent({super.key});

  @override
  State<TripJoinContent> createState() => _TripJoinContentState();
}

class _TripJoinContentState extends State<TripJoinContent>
    with TickerProviderStateMixin {
  String _displayedCategory = LocaleKeys.availableTrips;
  int selectedIndex = 1;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(children: [
          _buildStatusCategories(),
          Sizer(
            height: 10.h,
          ),

          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                switch (_displayedCategory) {
                  case LocaleKeys.availableTrips:
                    return AvailableTripsCard(
                      subscribtionPlan: context.isArabic?'العروض المميزة':LocaleKeys.premium.localize,
                      title: context.isArabic
                          ? 'كيا، سيراتو'
                          : 'Kia, Cerato',
                      buttonTitle: LocaleKeys.request.localize,
                      isMale: true,
                      time:
                      context.isArabic ? '8:00 مساء' : '8:00 Pm',
                      seats: 2,
                      status: context.isArabic ? 'مكرر' : 'Repeat',
                      isRequestButton: true,
                      isContactInfo: true,
                      iconCar: true,
                      onTab: () => JoinTripBottomSheet(context,
                          topButtonColor: AppColors.SECONDARY_COLOR,
                          topButtonTitle:
                          LocaleKeys.premium_request.localize,
                          bottomButtonColor: AppColors.PRIMARY_COLOR,
                          bottomButtonTitle:
                          LocaleKeys.request.localize,
                          onTap: () => SubmitBottomSheet(
                            context,
                            buttonColor: AppColors.PRIMARY_COLOR,
                            buttonTitle:
                            LocaleKeys.submit.localize,
                          )),
                    );

                  case LocaleKeys.requestLog:
                    return TripJoinCard(
                      subscribtionPlan: LocaleKeys.premium.localize,
                      title: context.isArabic ? 'محمد' : 'Mohamed',
                      isMale: true,
                      buttonTitle: LocaleKeys.request.localize,
                      time:
                      context.isArabic ? '8:00 مساء' : '8:00 Pm',
                      seats: 2,
                      status: context.isArabic ? 'انتهت' : 'Expired',
                      isRequestButton: false,
                      isContactInfo: true,
                      iconCar: false,
                      onTab: () {},
                    );
                  case LocaleKeys.myAds:
                    return TripJoinCard(
                      subscribtionPlan: LocaleKeys.premium.localize,
                      title: context.isArabic
                          ? 'كيا، سيراتو'
                          : 'Kia, Cerato',
                      isMale: true,
                      buttonTitle: LocaleKeys.deleteAd.localize,
                      time:
                      context.isArabic ? '8:00 مساء' : '8:00 Pm',
                      seats: 2,
                      status:
                      context.isArabic ? 'مرة واحدة' : 'One Time',
                      isRequestButton: true,
                      isContactInfo: false,
                      iconCar: true,
                      onTab: () => showDialogTripJoin(
                          context,
                          DialogContent(
                            subTitle:
                            LocaleKeys.areDeleteThisAd.localize,
                            leftButtonTitle:
                            LocaleKeys.deleteAd.localize,
                            rightButtonTitle:
                            LocaleKeys.close.localize,
                          )),
                    );
                }
              }),
        ]),
      ],
    );
  }

  _buildStatusCategories() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildCategory(
            title: LocaleKeys.availableTrips,
            index: 0,
          ),
        ),
        const Sizer(
          width: 10,
        ),
        Expanded(
          child: _buildCategory(
            title: LocaleKeys.requestLog,
            index: 1,
          ),
        ),
        const Sizer(
          width: 10,
        ),
        Expanded(
          child: _buildCategory(
            title: LocaleKeys.myAds,
            index: 2,
          ),
        ),
      ],
    );
  }

  _buildCategory({
    required String title,
    required int index,
  }) {
    bool selected = tabController.index == index;
    return GestureDetector(
      onTap: () {
        tabController.animateTo(index);
        setState(() {
          _displayedCategory = title;
        });
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10.h),
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.h),
                color: selected ? AppColors.PRIMARY_COLOR : AppColors.GREYBG,
                border: Border.all(
                    color: selected
                        ? AppColors.SECONDARY_COLOR
                        : AppColors.c0B1035,
                    width: 2)),
            child: Center(
              child: Text(
                title.localize,
                style: Styles.headerText(
                    fontSize: 24,
                    color: selected ? Colors.white : AppColors.black),
              ),
            ),
          ),
          Visibility(
            visible: title == LocaleKeys.requestLog,
            child: Positioned(
              top: -3.h,
              right: 4.h,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.SECONDARY_COLOR),
                child: Center(
                  child: Text(
                    '1k',
                    style: Styles.smallText(
                        color: AppColors.whiteColor, fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
