import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/cards/display_trip_join_card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_bottom_sheet/show_bottom_sheet.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_bottom_sheet/submit_bottom_sheet.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_dialog/dialog_content.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_dialog/show_dialog_trip_join.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../view_all_trip_join/presentation/views/Modified_widgets/cards/available_trips_card.dart';
import 'available_pickme_screen.dart';

class AllPickMeView extends StatefulWidget {
  const AllPickMeView({super.key});

  @override
  State<AllPickMeView> createState() => _AllPickMeViewState();
}

class _AllPickMeViewState extends State<AllPickMeView>
    with TickerProviderStateMixin {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _displayedCategory = LocaleKeys.availableTrips;

  //
  // late AnimationController _controller;
  // late Animation<double> _scaleAnimation;
  // late Animation<double> _positionAnimation;
  late TabController tabController;
  int selectedIndex = 0; // Changed to 0 to match availableTrips as default

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    // tabController.addListener(() {
    //   setState(() {});
    // });
    tabController.addListener(() {
      setState(() {
        selectedIndex = tabController.index;
        // Update category based on selected index
        switch (tabController.index) {
          case 0:
            _displayedCategory = LocaleKeys.availableTrips;
            break;
          case 1:
            _displayedCategory = LocaleKeys.requestLog;
            break;
          case 2:
            _displayedCategory = LocaleKeys.myAds;
            break;
        }
      });
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
          Expanded(child: _buildCardForCategory()),
          // Expanded(
          //   child: ListView.builder(
          //       physics: const NeverScrollableScrollPhysics(),
          //       shrinkWrap: true,
          //       itemCount: 3,
          //       itemBuilder: (BuildContext context, int index) {
          //         switch (_displayedCategory) {
          //           case LocaleKeys.availableTrips:
          //             return TripJoinCard(
          //               subscribtionPlan: LocaleKeys.notSubscribed.localize,
          //               title: context.isArabic
          //                   ? index == 0
          //                       ? 'Sara'
          //                       : 'Ibrahim'
          //                   : index == 0
          //                       ? 'ساره'
          //                       : 'ابراهيم',
          //               buttonTitle: LocaleKeys.request.localize,
          //               isMale: index == 0 ? false : true,
          //               time: context.isArabic ? '8:00 مساء' : '8:00 Pm',
          //               seats: 2,
          //               status: context.isArabic ? 'مكرر' : 'Repeat',
          //               isRequestButton: true,
          //               isContactInfo: true,
          //               iconCar: false,
          //               onTab: () => JoinTripBottomSheet(context,
          //                   topButtonColor: AppColors.getRedColor(context),
          //                   topButtonTitle: LocaleKeys.premium_request.localize,
          //                   bottomButtonColor:
          //                       AppColors.getButtonPrimaryColor(context),
          //                   bottomButtonTitle: LocaleKeys.request.localize,
          //                   onTap: () => SubmitBottomSheet(
          //                         context,
          //                         buttonColor: AppColors.PRIMARY_COLOR,
          //                         buttonTitle: LocaleKeys.submit.localize,
          //                       ),
          //                   topTextColor:
          //                       context.isDarkMode ? Colors.black : Colors.white,
          //                   bottomTextColor:
          //                       context.isDarkMode ? Colors.black : Colors.white),
          //             );
          //           case LocaleKeys.requestLog:
          //             return TripJoinCard(
          //               subscribtionPlan: LocaleKeys.notSubscribed.localize,
          //               title: context.isArabic ? 'محمد' : 'Mohamed',
          //               isMale: true,
          //               buttonTitle: LocaleKeys.request.localize,
          //               time: context.isArabic ? '8:00 مساء' : '8:00 Pm',
          //               seats: 2,
          //               status: context.isArabic ? 'انتهت' : 'Expired',
          //               isRequestButton: false,
          //               isContactInfo: true,
          //               iconCar: false,
          //               onTab: () {},
          //             );
          //           case LocaleKeys.myAds:
          //             return TripJoinCard(
          //               subscribtionPlan: LocaleKeys.notSubscribed.localize,
          //               title: context.isArabic
          //                   ? index == 0
          //                       ? 'Sara'
          //                       : 'Ibrahim'
          //                   : index == 0
          //                       ? 'ساره'
          //                       : 'ابراهيم',
          //               isMale: index == 0 ? false : true,
          //               buttonTitle: LocaleKeys.deleteAd.localize,
          //               time: context.isArabic ? '8:00 مساء' : '8:00 Pm',
          //               seats: 2,
          //               status: context.isArabic ? 'مرة واحدة' : 'One Time',
          //               isRequestButton: true,
          //               isContactInfo: false,
          //               iconCar: false,
          //               onTab: () => showDialogTripJoin(
          //                   context,
          //                   DialogContent(
          //                     subTitle: LocaleKeys.areDeleteThisAd.localize,
          //                     leftButtonTitle: LocaleKeys.deleteAd.localize,
          //                     rightButtonTitle: LocaleKeys.close.localize,
          //                   )),
          //             );
          //         }
          //       }),
          // ),
        ]),
      ],
    );
  }

  Widget _buildCardForCategory() {
    switch (_displayedCategory) {
      case LocaleKeys.availableTrips:
        //TODO: Dont forget to add CustomLoadingSearchWidget for loading state in every DisplayTripJoinCard
        // اياك تنسى 🙂🔪
        return AvailablePickMeCard();
      case LocaleKeys.requestLog:
        return SizedBox();
      case LocaleKeys.myAds:
        return SizedBox();

      default:
        return const SizedBox.shrink();
    }
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
      // onTap: () {
      //   tabController.animateTo(index);
      //   setState(() {
      //     _displayedCategory = title;
      //   });
      // },
      onTap: () {
        tabController.animateTo(index);
        if (index == 0) {
          // context.read<ViewAllTripJoinCubit>().loadInitialTripJoin();
          print("Fiiiiiiiiiirst");
        }
        if (index == 1) {
          print("Seeeeeecond");

          // context.read<ViewAllTripJoinCubit>().loadInitialRequestTripJoin();
        }
        setState(() {
          _displayedCategory = title;
          selectedIndex = index;
        });

        // Load data for the selected category
        // final cubit = context.read<ViewAllTripJoinCubit>();
        switch (title) {
          case LocaleKeys.availableTrips:
            break;
          case LocaleKeys.requestLog:
            break;
          case LocaleKeys.myAds:
            // cubit.loadInitialMyAds(); // Uncomment and reload when implemented
            break;
        }
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
                color: selected
                    ? AppColors.getButtonPrimaryColor(context)
                    : AppColors.getFillColor(context),
                border: Border.all(
                    color: selected
                        ? AppColors.getRedColor(context)
                        : AppColors.getButtonPrimaryColor(context),
                    width: 2)),
            child: Center(
              child: Text(
                title.localize,
                style: Styles.headerText(
                    fontSize: 24,
                    color: selected
                        ? context.isDarkMode
                            ? Colors.black
                            : Colors.white
                        : AppColors.getTextColor(context)),
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
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.getRedColor(context)),
                child: Center(
                  child: Text(
                    '1k',
                    style: Styles.smallText(
                        color: context.isDarkMode
                            ? Colors.black
                            : AppColors.whiteColor,
                        fontSize: 20),
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
