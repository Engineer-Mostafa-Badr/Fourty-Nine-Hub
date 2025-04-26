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
import 'package:fourtyninehub/features/new_trip_join/captainshare/screen/captain_share_screen.dart';
import 'package:fourtyninehub/features/new_trip_join/presentation/view/widget/captain_share_body.dart';
import 'package:fourtyninehub/features/new_trip_join/presentation/view/widget/trip_option_widget.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/presentation/views/all_pickme_view.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/trip_join_content.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/cards/available_trips_card.dart';
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

class TripJoinView extends StatefulWidget {
  const TripJoinView({super.key});

  @override
  State<TripJoinView> createState() => _TripJoinViewState();
}

class _TripJoinViewState extends State<TripJoinView>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _displayedCategory = LocaleKeys.availableTrips;
  int selectedIndex = 1;

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

  String getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return LocaleKeys.captainShare.localize;
      case 1:
        return LocaleKeys.tripJoin.localize;
      case 2:
        return LocaleKeys.pickMe.localize;
      default:
        return '';
    }
  }

  String? getIconForIndex(int index) {
    switch (index) {
      case 0:
        return null;
      case 1:
        return Assets.car;
      case 2:
        return Assets.pickMeImage;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
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
                          children: List.generate(3, (index) {
                            bool isSelected = selectedIndex == index;

                            Widget child = TripOptionWidget(
                              imagePath: Assets.locationTripIcon,
                              title: getTitleForIndex(index),
                              // function نعملها ترجعلنا العنوان
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                  _controller.forward(
                                      from: 0); // يبدأ الانيميشن من الأول
                                });
                              },
                              icon: getIconForIndex(index),
                              // function ترجع الايكون لو موجود
                              borderColor:
                                  index == selectedIndex ? Colors.red : null,
                              containerColor:
                                  index == selectedIndex ? Colors.white : null,
                              iconColor: index == selectedIndex
                                  ? const Color(0xffF33D49)
                                  : null,
                              textColor: index == selectedIndex
                                  ? const Color(0xffF33D49)
                                  : null,
                            );

                            if (isSelected) {
                              return AnimatedBuilder(
                                animation: _controller,
                                builder: (context, _) {
                                  return Transform.translate(
                                    offset: Offset(0, _positionAnimation.value),
                                    child: Transform.scale(
                                      scale: _scaleAnimation.value,
                                      child: child,
                                    ),
                                  );
                                },
                              );
                            } else {
                              return child;
                            }
                          }),
                        )

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     TripOptionWidget(
                        //       imagePath: Assets.locationTripIcon,
                        //       title:LocaleKeys.captainShare.localize,
                        //       onTap: () {
                        //         context.push(Routes.captainShareScreen);
                        //       },
                        //     ),
                        //     AnimatedBuilder(
                        //       animation: _controller,
                        //       builder: (context, child) {
                        //         return Transform.translate(
                        //           offset: Offset(0, _positionAnimation.value),
                        //           child: Transform.scale(
                        //             scale: _scaleAnimation.value,
                        //             child: child,
                        //           ),
                        //         );
                        //       },
                        //       child: TripOptionWidget(
                        //         borderColor: Colors.red,
                        //         containerColor: Colors.white,
                        //         iconColor: const Color(0xffF33D49),
                        //         textColor: const Color(0xffF33D49),
                        //         imagePath: Assets.locationTripIcon,
                        //         title: LocaleKeys.tripJoin.localize,
                        //         onTap: () {},
                        //         icon: Assets.car,
                        //       ),
                        //     ),
                        //     TripOptionWidget(
                        //       imagePath: Assets.locationTripIcon,
                        //       title: LocaleKeys.pickMe.localize,
                        //       onTap: () {context.push(Routes.All_PickMe_View);},
                        //       icon: Assets.pickMeImage,
                        //     ),
                        //   ],
                        // ),
                        ),
                    const Sizer(),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: getSelectedContent(selectedIndex),
                    ),
                    // _buildStatusCategories(),
                    // Sizer(
                    //   height: 10.h,
                    // ),

                    // ListView.builder(
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     shrinkWrap: true,
                    //     itemCount: 2,
                    //     itemBuilder: (BuildContext context, int index) {
                    //       switch (_displayedCategory) {
                    //         case LocaleKeys.availableTrips:
                    //           return AvailableTripsCard(
                    //             subscribtionPlan: LocaleKeys.premium.localize,
                    //             title: context.isArabic
                    //                 ? 'كيا، سيراتو'
                    //                 : 'Kia, Cerato',
                    //             buttonTitle: LocaleKeys.request.localize,
                    //             isMale: true,
                    //             time:
                    //                 context.isArabic ? '8:00 مساء' : '8:00 Pm',
                    //             seats: 2,
                    //             status: context.isArabic ? 'مكرر' : 'Repeat',
                    //             isRequestButton: true,
                    //             isContactInfo: true,
                    //             iconCar: true,
                    //             onTab: () => JoinTripBottomSheet(context,
                    //                 topButtonColor: AppColors.SECONDARY_COLOR,
                    //                 topButtonTitle:
                    //                     LocaleKeys.premium_request.localize,
                    //                 bottomButtonColor: AppColors.PRIMARY_COLOR,
                    //                 bottomButtonTitle:
                    //                     LocaleKeys.request.localize,
                    //                 onTap: () => SubmitBottomSheet(
                    //                       context,
                    //                       buttonColor: AppColors.PRIMARY_COLOR,
                    //                       buttonTitle:
                    //                           LocaleKeys.submit.localize,
                    //                     )),
                    //           );
                    //           break;
                    //
                    //         case LocaleKeys.rideRequest:
                    //           return TripJoinCard(
                    //             subscribtionPlan: LocaleKeys.premium.localize,
                    //             title: context.isArabic ? 'محمد' : 'Mohamed',
                    //             isMale: true,
                    //             buttonTitle: LocaleKeys.request.localize,
                    //             time:
                    //                 context.isArabic ? '8:00 مساء' : '8:00 Pm',
                    //             seats: 2,
                    //             status: context.isArabic ? 'انتهت' : 'Expired',
                    //             isRequestButton: false,
                    //             isContactInfo: true,
                    //             iconCar: false,
                    //             onTab: () {},
                    //           );
                    //           break;
                    //         case LocaleKeys.myAds:
                    //           return TripJoinCard(
                    //             subscribtionPlan: LocaleKeys.premium.localize,
                    //             title: context.isArabic
                    //                 ? 'كيا، سيراتو'
                    //                 : 'Kia, Cerato',
                    //             isMale: true,
                    //             buttonTitle: LocaleKeys.deleteAd.localize,
                    //             time:
                    //                 context.isArabic ? '8:00 مساء' : '8:00 Pm',
                    //             seats: 2,
                    //             status:
                    //                 context.isArabic ? 'مرة واحدة' : 'One Time',
                    //             isRequestButton: true,
                    //             isContactInfo: false,
                    //             iconCar: true,
                    //             onTab: () => showDialogTripJoin(
                    //                 context,
                    //                 DialogContent(
                    //                   subTitle:
                    //                       LocaleKeys.areDeleteThisAd.localize,
                    //                   leftButtonTitle:
                    //                       LocaleKeys.deleteAd.localize,
                    //                   rightButtonTitle:
                    //                       LocaleKeys.close.localize,
                    //                 )),
                    //           );
                    //           break;
                    //       }
                    //     }),
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
                switch (selectedIndex) {
                  case 0:
                    context.push(Routes.captainShareInfoScreen);
                  case 1:
                    context.push(Routes.tripJoinInfoScreen);
                  case 2:
                    context.push(Routes.pickMeInfoScreen);

                  default:
                    () {};
                }
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
          getFloatingActionButtonContent(selectedIndex),
        ],
      ),
      mainCategoryId: 1,
      isWithBackArrow: false,
    );
  }

  Widget getSelectedContent(int? index) {
    switch (index) {
      case 0:
        return
          Container(
          key: const ValueKey(0),
          child: const CaptainShareBody(),
        );
      case 1:
        return Container(
          key: const ValueKey(1),
          child: const TripJoinContent(),
        );
      case 2:
        return Container(
          key: const ValueKey(2),
          child: const AllPickMeView(),
        );
      default:
        return const SizedBox.shrink(); // لما مفيش حاجة مختارة
    }
  }

  Widget getFloatingActionButtonContent(int? index) {
    switch (index) {
      case 0:
        return TripJoinFloatingActionButton(
          title: context.isArabic ? "أعلن عن سيارتك" : "Advertise your car",
          onTap: () {
            context.push(Routes.TRIP_JOIN);
          },
        );
      case 1:
        return Container(
          key: const ValueKey(1),
          child: TripJoinFloatingActionButton(
            title: context.isArabic ? "أعلن عن سيارتك" : "Advertise your car",
            onTap: () {
              context.push(Routes.TRIP_JOIN);
            },
          ),
        );
      case 2:
        return Container(
          key: const ValueKey(2),
          child: TripJoinFloatingActionButton(
            title: context.isArabic ? "انشر رحلتك" : "Post your ride",
            onTap: () {
              context.push(Routes.AddNewPickMe);
            },
          ),
        );
      default:
        return const SizedBox.shrink(); // لما مفيش حاجة مختارة
    }
  }
}
