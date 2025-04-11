import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/handle_cashback.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/new_trip_join/presentation/view/widget/trip_option_widget.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/cards/display_trip_join_card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_bottom_sheet/show_bottom_sheet.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_bottom_sheet/submit_bottom_sheet.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_dialog/dialog_content.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_dialog/show_dialog_trip_join.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_floating_action_button.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routes/routes.dart';

class AllPickMeView extends StatefulWidget {
  const AllPickMeView({super.key});

  @override
  State<AllPickMeView> createState() => _AllPickMeViewState();
}

class _AllPickMeViewState extends State<AllPickMeView>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _displayedCategory = LocaleKeys.availableTrips;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _positionAnimation;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnimation = Tween<double>(
            begin: 0.6, end: 1.2) // تكبير أكبر من البقية
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _positionAnimation = Tween<double>(begin: 200, end: 0) // يبدأ من تحت الشاشة
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // تأخير بسيط ثم تشغيل الأنيميشن
    Future.delayed(const Duration(milliseconds: 250), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SharedScaffold(
        mainCategoryId: 1,isWithBackArrow: false,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.h),
                child: Stack(
                  children: [
                    Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: AppColors.PRIMARY_COLOR,
                              )),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 15.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TripOptionWidget(
                              imagePath: Assets.locationTripIcon,
                              title: 'Captain\nShare',
                              onTap: () {
                                context.push(Routes.captainShareScreen);
                              },
                            ),
                            TripOptionWidget(
                              imagePath: Assets.locationTripIcon,
                              title: 'Trip Join',
                              onTap: () {
                                context.push(Routes.AVAILABLE_TRIPS);
                              },
                              icon: Assets.car,
                            ),
                            AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _positionAnimation.value),
                                  child: Transform.scale(
                                    scale: _scaleAnimation.value,
                                    child: child,
                                  ),
                                );
                              },
                              child: TripOptionWidget(
                                borderColor: Colors.red,
                                containerColor: Colors.white,
                                iconColor: const Color(0xffF33D49),
                                textColor: const Color(0xffF33D49),
                                imagePath: Assets.locationTripIcon,
                                title: 'Pick me',
                                onTap: () {},
                                icon: Assets.pickMeImage,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Sizer(),
                      _buildStatusCategories(),
                      Sizer(
                        height: 10.h,
                      ),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (BuildContext context, int index) {
                            switch (_displayedCategory) {
                              case LocaleKeys.availableTrips:
                                return TripJoinCard(
                                  subscribtionPlan:
                                      LocaleKeys.notSubscribed.localize,
                                  title: context.isArabic
                                      ? index == 0
                                          ? 'Sara'
                                          : 'Ibrahim'
                                      : index == 0
                                          ? 'ساره'
                                          : 'ابراهيم',
                                  buttonTitle: LocaleKeys.request.localize,
                                  isMale: index == 0 ? false : true,
                                  time: context.isArabic
                                      ? '8:00 مساء'
                                      : '8:00 Pm',
                                  seats: 2,
                                  status: context.isArabic ? 'مكرر' : 'Repeat',
                                  isRequestButton: true,
                                  isContactInfo: true,
                                  iconCar: false,
                                  onTab: () => JoinTripBottomSheet(context,
                                      topButtonColor: AppColors.SECONDARY_COLOR,
                                      topButtonTitle:
                                          LocaleKeys.premium_request.localize,
                                      bottomButtonColor:
                                          AppColors.PRIMARY_COLOR,
                                      bottomButtonTitle:
                                          LocaleKeys.request.localize,
                                      onTap: () => SubmitBottomSheet(
                                            context,
                                            buttonColor:
                                                AppColors.PRIMARY_COLOR,
                                            buttonTitle:
                                                LocaleKeys.submit.localize,
                                          )),
                                );
                                break;

                              case LocaleKeys.rideRequest:
                                return TripJoinCard(
                                  subscribtionPlan:
                                      LocaleKeys.notSubscribed.localize,
                                  title: context.isArabic ? 'محمد' : 'Mohamed',
                                  isMale: true,
                                  buttonTitle: LocaleKeys.request.localize,
                                  time: context.isArabic
                                      ? '8:00 مساء'
                                      : '8:00 Pm',
                                  seats: 2,
                                  status:
                                      context.isArabic ? 'انتهت' : 'Expired',
                                  isRequestButton: false,
                                  isContactInfo: true,
                                  iconCar: false,
                                  onTab: () {},
                                );
                                break;
                              case LocaleKeys.myAds:
                                return TripJoinCard(
                                  subscribtionPlan:
                                      LocaleKeys.notSubscribed.localize,
                                  title: context.isArabic
                                      ? index == 0
                                          ? 'Sara'
                                          : 'Ibrahim'
                                      : index == 0
                                          ? 'ساره'
                                          : 'ابراهيم',
                                  isMale: index == 0 ? false : true,
                                  buttonTitle: LocaleKeys.deleteAd.localize,
                                  time: context.isArabic
                                      ? '8:00 مساء'
                                      : '8:00 Pm',
                                  seats: 2,
                                  status: context.isArabic
                                      ? 'مرة واحدة'
                                      : 'One Time',
                                  isRequestButton: true,
                                  isContactInfo: false,
                                  iconCar: false,
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
                                break;
                            }
                          }),
                    ]),
                  ],
                ),
              ),
            ),
            Positioned.directional(
              bottom: 40.h,
              start: 10,
              textDirection:
                  context.isArabic ? TextDirection.rtl : TextDirection.ltr,
              child: GestureDetector(
                onTap: () {
                  context.push(Routes.pickMeInfoScreen);
                },
                child: Container(
                  height: 48.h,
                  width: 48.h,
                  decoration: BoxDecoration(
                      color: const Color(0xff0B1035),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(
                    size: 19,
                    Icons.question_mark,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            TripJoinFloatingActionButton(
              onTap: () {
                context.push(Routes.AddNewPickMe);
              },
              title: context.isArabic ? 'انشر رحلتك' : "Post your ride",
            ),
          ],
        ),
      ),
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
            // selected: _displayedCategory == LocaleKeys.availableTrips
            //     ? true
            //     : false
          ),
        ),
        const Sizer(
          width: 10,
        ),
        Expanded(
          child: _buildCategory(
            title: LocaleKeys.rideRequest,
            index: 1,
            // selected: _displayedCategory == LocaleKeys.rideRequest
            //     ? true
            //     : false
          ),
        ),
        const Sizer(
          width: 10,
        ),
        Expanded(
          child: _buildCategory(
            title: LocaleKeys.myAds,
            index: 2,
            // selected:
            //     _displayedCategory == LocaleKeys.myAds ? true : false
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
            visible: title == LocaleKeys.rideRequest,
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

// import 'package:flutter/material.dart';
// import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
// import 'package:fourtyninehub/features/trip_join/view_all_pick_me/presentation/widgets/all_pick_me_body.dart';
// import 'package:fourtyninehub/features/trip_join/view_all_pick_me/presentation/widgets/all_pickme_floating_action_button.dart';
//
// class AllPickMeView extends StatelessWidget {
//   const AllPickMeView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const SharedScaffold(mainCategoryId: 1, body:  Stack(
//       children: [
//         SizedBox(width: double.infinity, height: double.infinity),
//         AllPickMeBody(),
//         AllPickMeFloatingActionButton(),
//       ],
//     ));
//   }
// }
