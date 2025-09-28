import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/dynamic/shared_scaffold.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../new_trip_join/captainshare/screen/captain_share_screen.dart';
import '../../../../new_trip_join/presentation/view/widget/trip_option_widget.dart';
import '../../../view_all_pick_me/presentation/views/all_pickme_view.dart';
import '../cubits/view_all_trip_join_cubit/view_all_trip_join_cubit.dart';
import 'trip_join_content.dart';
import 'Modified_widgets/trip_join_floating_action_button.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../helpers/manage_vibration.dart';
import '../../../../../routes/routes.dart';
import '../../../../../helpers/manage_vibration.dart';

class TripJoinView extends StatefulWidget {
  const TripJoinView({
    super.key,
    required this.initialIndex,
  });
  final int initialIndex;
  @override
  State<TripJoinView> createState() => _TripJoinViewState();
}

class _TripJoinViewState extends State<TripJoinView>
    with TickerProviderStateMixin {
  late int selectedIndex;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _positionAnimation;
  late TabController tabController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
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
      mainCategoryId: 1,
      isWithBackArrow: true,

      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.h),
              child: Column(children: [
                const Sizer(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(3, (index) {
                    bool isSelected = selectedIndex == index;
                    Widget child = TripOptionWidget(
                      imagePath: Assets.locationTripIcon,
                      title: getTitleForIndex(index),
                      onTap: () {
                        ManageVibration.vibrate();
                        setState(() {
                          selectedIndex = index;
                          _controller.forward(from: 0);
                        });
                      },
                      icon: getIconForIndex(index),
                      borderColor: index == selectedIndex ? Colors.red : null,
                      containerColor: index == selectedIndex
                          ? context.isDarkMode
                              ? AppColors.Scaffold_Color_DARK
                              : Colors.white
                          : null,
                      iconColor: index == selectedIndex
                          ? AppColors.getRedColor(context)
                          : AppColors.getButtonPrimaryColor(context),
                      textColor: index == selectedIndex
                          ? AppColors.getRedColor(context)
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
                ),
                const Sizer(
                  height: 20,
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: getSelectedContent(selectedIndex),
                  ),
                ),
              ]),
            ),
            // if(selectedIndex!=0)Positioned.directional(
            //   bottom: 40.h,
            //   start: 10,
            //   textDirection:
            //       context.isArabic ? TextDirection.rtl : TextDirection.ltr,
            //   child: GestureDetector(
            //     onTap: () {
            //       switch (selectedIndex) {
            //         case 0:
            //           context.push(Routes.captainShareInfoScreen);
            //         case 1:
            //           context.push(Routes.tripJoinInfoScreen);
            //         case 2:
            //           context.push(Routes.pickMeInfoScreen);
            //
            //         default:
            //           () {};
            //       }
            //     },
            //     child: Container(
            //       height: 48.h,
            //       width: 48.h,
            //       decoration: BoxDecoration(
            //           color: AppColors.getButtonPrimaryColor(context),
            //           borderRadius: BorderRadius.circular(10)),
            //       child: Icon(
            //         size: 19,
            //         Icons.question_mark,
            //         color: context.isDarkMode?AppColors.black:Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
            // if (selectedIndex != 0 && selectedIndex != 1)
            //   PositionedDirectional(
            //       bottom: 30.h,
            //       end: 10,
            //       start: 10,
            //       // textDirection:
            //       // context.isArabic ? TextDirection.rtl : TextDirection.ltr,
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           GestureDetector(
            //             onTap: () {
            //               ManageVibration.vibrate();
            //               switch (selectedIndex) {
            //                 case 0:
            //                   context.push(Routes.captainShareInfoScreen);
            //                 case 1:
            //                   context.push(Routes.tripJoinInfoScreen);
            //                 case 2:
            //                   context.push(Routes.pickMeInfoScreen);
            //
            //                 default:
            //                   () {};
            //               }
            //             },
            //             child: Container(
            //               height: 48.h,
            //               width: 48.h,
            //               decoration: BoxDecoration(
            //                   color: AppColors.getButtonPrimaryColor(context),
            //                   borderRadius: BorderRadius.circular(10)),
            //               child: Icon(
            //                 size: 19,
            //                 Icons.question_mark,
            //                 color: context.isDarkMode
            //                     ? AppColors.black
            //                     : Colors.white,
            //               ),
            //             ),
            //           ),
            //           // getFloatingActionButtonContent(selectedIndex),
            //         ],
            //       )),
          ],
        ),
      ),
    );
  }

  Widget getSelectedContent(int? index) {
    switch (index) {
      case 0:
        return Container(
          key: const ValueKey(0),
          child: const CaptainShareScreen(),
        );
      case 1:
        return Container(
          key: const ValueKey(1),
          child: BlocProvider(
              create: (context) => serviceLocator<ViewAllTripJoinCubit>(),
              child: const TripJoinContent()),
        );
      case 2:
        return Container(
          key: const ValueKey(2),
          child: const AllPickMeView(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  // Widget getFloatingActionButtonContent(int? index) {
  //   switch (index) {
  //     case 0:
  //       return TripJoinFloatingActionButton(
  //         title: LocaleKeys.createRoute.localize,
  //         onTap: () {
  //           ManageVibration.vibrate();
  //           context.push(Routes.newRouteScreen);
  //         },
  //       );
  //     case 1:
  //       return Container(
  //         key: const ValueKey(1),
  //         child: TripJoinFloatingActionButton(
  //           title: context.isArabic ? "أعلن عن سيارتك" : "Advertise your car",
  //           onTap: () {
  //             ManageVibration.vibrate();
  //             context.push(Routes.TRIP_JOIN);
  //           },
  //         ),
  //       );
  //     case 2:
  //       return Container(
  //         key: const ValueKey(2),
  //         child: TripJoinFloatingActionButton(
  //           title: context.isArabic ? "انشر رحلتك" : "Post your ride",
  //           onTap: () {
  //             ManageVibration.vibrate();
  //             context.push(Routes.TRIP_JOIN, extra: true);
  //           },
  //         ),
  //       );
  //     default:
  //       return const SizedBox.shrink(); // لما مفيش حاجة مختارة
  //   }
  // }
}
