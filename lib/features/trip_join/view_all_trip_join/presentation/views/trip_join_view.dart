import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/handle_cashback.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/cards/display_trip_join_card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_bottom_sheet/show_bottom_sheet.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_dialog/dialog_content.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_dialog/show_dialog_trip_join.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_floating_action_button.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TripJoinView extends StatefulWidget {
  const TripJoinView({super.key});

  @override
  State<TripJoinView> createState() => _TripJoinViewState();
}

class _TripJoinViewState extends State<TripJoinView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _displayedCategory = LocaleKeys.availableTrips;
  List categories=['','',''];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: CustomScaffold(
            appBar: HomeAppbar(
              showChat: true,
              isWithBackArrow: false,
              language: true,
              leading: IconButton(
                icon: const Icon(Icons.menu), // The menu icon
                onPressed: () {
                  HandleCashback.setCount('drawerCount', context);
                  _scaffoldKey.currentState?.openDrawer(); // Open the drawer
                },
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric( horizontal: 32.h),
                    child: Stack(
                      children: [
                        Column(children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                           IconButton(
                               onPressed: () => Navigator.of(context).pop(),
                               icon:const Icon(Icons.arrow_back,color: AppColors.PRIMARY_COLOR,)),
                         ],),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: 15.h,
                                ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildCategoryIcons(
                                    image: Assets.tripJoinCaptainShare,
                                    title: context.isArabic
                                        ? "مشاركة كابتن"
                                        : "Captain\n Share"),
                                _buildCategoryIcons(
                                    image: Assets.tripJoinIconSelected,
                                    title: context.isArabic ? "جاي معاك" : "Trip Join"),
                                _buildCategoryIcons(
                                    image: Assets.tripJoinPickMe,
                                    title: context.isArabic ? "وصلني معاك" : "Pick me"),
                              ],
                            ),
                          ),
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
                                    return TripJoinCard(
                                      title: context.isArabic
                                          ? 'كيا، سيراتو'
                                          : 'Kia, Cerato',
                                      buttonTitle: LocaleKeys.request.localize,
                                      isMale: true,
                                      time: context.isArabic ? '8:00 مساء' : '8:00 Pm',
                                      seats: 2,
                                      status: context.isArabic ? 'مكرر' : 'Repeat',
                                      isRequestButton: true,
                                      isContactInfo: true,
                                      iconCar: true,
                                      onTab: ()=>JoinTripBottomSheet(context,
                                topButtonColor: AppColors.SECONDARY_COLOR,
                                topButtonTitle: LocaleKeys.premium_request.localize,
                                bottomButtonColor: AppColors.PRIMARY_COLOR,
                                bottomButtonTitle: LocaleKeys.request.localize),
                                    );
                                    break;

                                  case LocaleKeys.rideRequest:
                                    return TripJoinCard(
                                      title: context.isArabic ? 'محمد' : 'Mohamed',
                                      isMale: true,
                                      buttonTitle: LocaleKeys.request.localize,
                                      time: context.isArabic ? '8:00 مساء' : '8:00 Pm',
                                      seats: 2,
                                      status: context.isArabic ? 'انتهت' : 'Expired',
                                      isRequestButton: false,
                                      isContactInfo: true,
                                      iconCar: false,
                                      onTab: (){},
                                    );
                                    break;
                                  case LocaleKeys.myAds:
                                    return TripJoinCard(
                                      title: context.isArabic
                                          ? 'كيا، سيراتو'
                                          : 'Kia, Cerato',
                                      isMale: true,
                                      buttonTitle: LocaleKeys.deleteAd.localize,
                                      time: context.isArabic ? '8:00 مساء' : '8:00 Pm',
                                      seats: 2,
                                      status:
                                          context.isArabic ? 'مرة واحدة' : 'One Time',
                                      isRequestButton: true,
                                      isContactInfo: false,
                                      iconCar: true,
                                      onTab: () => showDialogTripJoin(
                                          context,
                                          DialogContent(
                                            subTitle: LocaleKeys.areDeleteThisAd.localize,
                                            leftButtonTitle: LocaleKeys.deleteAd.localize,
                                            rightButtonTitle: LocaleKeys.close.localize,
                                          )),
                                    );
                                    break;
                                }
                              }),
                            ]),

                      ],
                    ),
                  ),
                ),
                TripJoinFloatingActionButton(),
              ],
            )));
  }

  _buildCategoryIcons({
    required String image,
    required String title,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        child: Column(
          children: [
            Image.asset(
              image,
            ),
            Text(
              title,
              style: Styles.headerText(),
            ),
          ],
        ),
      ),
    );
  }

  _buildStatusCategories() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
      [
        Expanded(
          child: _buildCategory(
              title: LocaleKeys.availableTrips,
              selected: _displayedCategory == LocaleKeys.availableTrips
                  ? true
                  : false),
        ),
        const Sizer(
          width: 10,
        ),
        Expanded(
          child: _buildCategory(
              title: LocaleKeys.rideRequest,
              selected: _displayedCategory == LocaleKeys.rideRequest
                  ? true
                  : false),
        ),
        const Sizer(
          width: 10,
        ),
        Expanded(
          child: _buildCategory(
              title: LocaleKeys.myAds,
              selected:
                  _displayedCategory == LocaleKeys.myAds ? true : false),
        ),
      ],
    );
  }

  _buildCategory({required String title, required bool selected,}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _displayedCategory = title;
        });
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top:10.h),
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
            visible: title==LocaleKeys.rideRequest,
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
