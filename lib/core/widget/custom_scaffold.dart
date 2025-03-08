import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:floating_draggable_widget/floating_draggable_widget.dart';

import '../../common/widgets/stateless/labels/label.dart';
import '../../features/settings/presentation/cubit/choice_ruler_cubit.dart';
import '../../features/settings/presentation/cubit/floating_navigator_cubit.dart';
import '../../res/assets/assets.dart';
import '../../res/style/app_colors.dart';
import '../../routes/routes.dart';
import '../localization/locale_keys.g.dart';

class CustomScaffold extends StatefulWidget {
  const CustomScaffold({
    super.key,
    required this.body,
    this.backgroundColor,
    this.floatingActionButtonLocation,
    this.floatingActionButton,
    this.drawer,
    this.bottomNavigationBar,
    this.appBar,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.enableCustomAppBar = false,
    this.bottomSheet,
    this.resizeToAvoidBottomInset,
  });

  final Widget body;
  final Color? backgroundColor;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final bool? resizeToAvoidBottomInset;
  final Widget? bottomSheet;
  final bool enableCustomAppBar;

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold>
    with SingleTickerProviderStateMixin {
  bool floatNavigator = false;

  @override
  Widget build(BuildContext context) {
    var floatingNavigatorCubit = FloatingNavigatorCubit.get(context);
    return BlocBuilder<FloatingNavigatorCubit, FloatingNavigatorState>(
      builder: (context, state) {
        if (floatingNavigatorCubit.floatingNavigatorStatus) {
          return FloatingDraggableWidget(
            mainScreenWidget: MainScaffold(
              backgroundColor: widget.backgroundColor,
              floatingActionButtonLocation: widget.floatingActionButtonLocation,
              floatingActionButton: widget.floatingActionButton,
              drawer: widget.drawer,
              bottomNavigationBar: widget.bottomNavigationBar,
              body: widget.body,
              appBar: widget.appBar,
              extendBody: widget.extendBody,
              extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
              bottomSheet: widget.bottomSheet,
              resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
              enableCustomAppBar: widget.enableCustomAppBar,
              rulerWidget: rulerWidget(),
            ),
            floatingWidget: GestureDetector(
              onTap: () {
                setState(() {
                  floatNavigator = !floatNavigator;
                });
              },
              child: Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                        color: AppColors.SECONDARY_COLOR,
                        borderRadius: BorderRadius.circular(15.r)),
                    child: const Icon(
                      Icons.swap_horiz_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 32,
                    height: 28,
                    child: FittedBox(
                      child: Label(
                        text: 'Move',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingWidgetHeight: 60,
            floatingWidgetWidth: 50,
            autoAlign: true,
          );
        } else {
          return MainScaffold(
            backgroundColor: widget.backgroundColor,
            floatingActionButtonLocation: widget.floatingActionButtonLocation,
            floatingActionButton: widget.floatingActionButton,
            drawer: widget.drawer,
            bottomNavigationBar: widget.bottomNavigationBar,
            body: widget.body,
            appBar: widget.appBar,
            extendBody: widget.extendBody,
            extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
            bottomSheet: widget.bottomSheet,
            resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
            enableCustomAppBar: widget.enableCustomAppBar,
            rulerWidget: rulerWidget(),
          );
        }
      },
    );
  }

  Widget drawerRollWidget({
    required String label,
    required String image,
    required void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            image,
            width: 40.h,
            height: 40.h,
            fit: BoxFit.cover,
          ),
          // Label(
          //     text: label,
          //     style: Styles.mediumText(
          //         fontWeight: FontWeight.w400, color: Colors.black)),
        ],
      ),
    );
  }

  Widget rulerWidget() {
    return PositionedDirectional(
      start: 0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          floatNavigator
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadiusDirectional.horizontal(
                      end: Radius.circular(30.r),
                    ),
                    border: const BorderDirectional(
                      end: BorderSide(
                        color: AppColors.PRIMARY_COLOR,
                        width: 2,
                      ),
                      top: BorderSide(
                        color: AppColors.PRIMARY_COLOR,
                        width: 2,
                      ),
                      bottom: BorderSide(
                        color: AppColors.PRIMARY_COLOR,
                        width: 2,
                      ),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32, horizontal: 16),
                    child: Column(
                      spacing: 32.h,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        drawerRollWidget(
                          label: LocaleKeys.ride.localize,
                          image: Assets.rideIcon,
                          onTap: () => context.push(Routes.RIDE),
                        ),
                        drawerRollWidget(
                          label: LocaleKeys.loading.localize,
                          image: Assets.loading,
                          // onTap: () {},
                          onTap: () =>
                              context.push(Routes.createLoadingTripScreen),
                        ),
                        drawerRollWidget(
                          label: LocaleKeys.health.localize,
                          image: Assets.healthIcon,
                          onTap: () => context.push(Routes.VISITA),
                        ),
                        drawerRollWidget(
                          label: LocaleKeys.meal.localize,
                          image: Assets.meal,
                          onTap: () => context.push(Routes.FOOD),
                        ),
                        drawerRollWidget(
                          label: LocaleKeys.find.localize,
                          image: Assets.find,
                          onTap: () => context.push(Routes.Tinder),
                        ),
                        drawerRollWidget(
                          label: LocaleKeys.reel.localize,
                          image: Assets.reel,
                          onTap: () => context.push(Routes.REELS),
                        ),
                        drawerRollWidget(
                          label: LocaleKeys.spotlight.localize,
                          image: Assets.spotlight,
                          onTap: () => context.push(Routes.SPOTLIGHT),
                        ),
                        drawerRollWidget(
                          label: LocaleKeys.meet.localize,
                          image: Assets.meet,
                          onTap: () => context.push(Routes.MEETINGROOM),
                        ),
                        drawerRollWidget(
                          label: LocaleKeys.live.localize,
                          image: Assets.liveIcon,
                          onTap: () => context.push(Routes.LIVE),
                        ),
                        drawerRollWidget(
                          label: LocaleKeys.snap.localize,
                          image: Assets.snap,
                          onTap: () => context.push(Routes.SNAP),
                        ),
                        drawerRollWidget(
                          label: LocaleKeys.chat.localize,
                          image: Assets.whatsApp,
                          onTap: () => context.push(Routes.CHAT),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          Material(
            color: Colors.transparent,
            child: ClickableWidget(
              onTap: () {
                setState(() {
                  floatNavigator = !floatNavigator;
                  print('taped $floatNavigator');
                });
              },
              child: Container(
                width: 40,
                color: Colors.transparent,
                alignment: AlignmentDirectional.topStart,
                child: Container(
                  // padding: EdgeInsets.all(50),
                  height: 100,
                  width: 10,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    border: const BorderDirectional(
                      end: BorderSide(
                        color: AppColors.PRIMARY_COLOR,
                        width: 2,
                      ),
                      top: BorderSide(
                        color: AppColors.PRIMARY_COLOR,
                        width: 2,
                      ),
                      bottom: BorderSide(
                        color: AppColors.PRIMARY_COLOR,
                        width: 2,
                      ),
                    ),
                    borderRadius: BorderRadiusDirectional.horizontal(
                      end: Radius.circular(20.r),
                    ),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 10)
                    ],
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

class Ruler extends StatelessWidget {
  const Ruler({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MainScaffold extends StatelessWidget {
  MainScaffold({
    super.key,
    required this.body,
    this.backgroundColor,
    this.floatingActionButtonLocation,
    this.floatingActionButton,
    this.drawer,
    this.bottomNavigationBar,
    this.appBar,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.enableCustomAppBar = false,
    this.bottomSheet,
    this.resizeToAvoidBottomInset,
    required this.rulerWidget,
  });

  final Widget body;
  final Color? backgroundColor;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final bool? resizeToAvoidBottomInset;
  final Widget? bottomSheet;
  final bool enableCustomAppBar;
  final Widget rulerWidget;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChoiceRulerCubit, ChoiceRulerState>(
      builder: (context, state) {
        var choiceRulerCubit = context.read<ChoiceRulerCubit>();
        if (enableCustomAppBar) {
          return Scaffold(
            backgroundColor: AppColors.PRIMARY_COLOR,
            floatingActionButtonLocation: floatingActionButtonLocation,
            floatingActionButton: floatingActionButton,
            drawer: drawer,
            onDrawerChanged: (value) {
              choiceRulerCubit.changeChoiceRulerStatus();

              // if (choiceRulerCubit.choiceRulerEnabled) {
              //   if (choiceRulerCubit.choiceRulerStatus) {
              //     choiceRulerCubit.unActiveChoiceRuler();
              //   } else {
              //     choiceRulerCubit.changeChoiceRulerStatus();
              //   }
              // }
              print('choiceRulerCubit.state ${choiceRulerCubit.state}');

              // cubit.choiceRulerStatus = value;
              // print('isRulerOpen ${cubit.choiceRulerStatus}');
            },
            bottomNavigationBar: bottomNavigationBar,
            body: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor ??
                      Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(50.r),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    body,
                    if (!choiceRulerCubit.choiceRulerStatus) rulerWidget,
                  ],
                ),
              ),
            ),
            appBar: appBar,
            extendBody: extendBody,
            extendBodyBehindAppBar: extendBodyBehindAppBar,
            bottomSheet: bottomSheet,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          );
        } else {
          return Scaffold(
            backgroundColor: backgroundColor,
            floatingActionButtonLocation: floatingActionButtonLocation,
            floatingActionButton: floatingActionButton,
            drawer: drawer,
            onDrawerChanged: (value) {
              if (choiceRulerCubit.choiceRulerEnabled) {
                choiceRulerCubit.changeChoiceRulerStatus();

                // if (choiceRulerCubit.choiceRulerStatus) {
                //   choiceRulerCubit.unActiveChoiceRuler();
                // } else {
                //   choiceRulerCubit.changeChoiceRulerStatus();
                // }
              }
              // if (choiceRulerCubit.state is !UnActiveChoiceRulerStatusState) {
              //   choiceRulerCubit.unActiveChoiceRuler();
              // }
              // if (choiceRulerCubit.state is !ActiveChoiceRulerStatusState) {
              //   choiceRulerCubit.activeChoiceRuler();
              // }
              print('choiceRulerCubit.state ${choiceRulerCubit.state}');
            },
            bottomNavigationBar: bottomNavigationBar,
            body: Stack(
              alignment: Alignment.centerLeft,
              children: [
                body,
                if (!choiceRulerCubit.choiceRulerStatus) rulerWidget,
              ],
            ),
            appBar: appBar,
            extendBody: extendBody,
            extendBodyBehindAppBar: extendBodyBehindAppBar,
            bottomSheet: bottomSheet,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          );
        }
      },
    );
    // return enableCustomAppBar
    //     ? Scaffold(
    //         backgroundColor: AppColors.PRIMARY_COLOR,
    //         floatingActionButtonLocation: floatingActionButtonLocation,
    //         floatingActionButton: floatingActionButton,
    //         drawer: drawer,
    //         onDrawerChanged: (value) {
    //           var choiceRulerCubit = context.read<ChoiceRulerCubit>();
    //           if (choiceRulerCubit.state is ActiveChoiceRulerStatusState) {
    //             choiceRulerCubit.unActiveChoiceRuler();
    //           }
    //           if (choiceRulerCubit.state is UnActiveChoiceRulerStatusState) {
    //             choiceRulerCubit.activeChoiceRuler();
    //           }
    //           // cubit.choiceRulerStatus = value;
    //           // print('isRulerOpen ${cubit.choiceRulerStatus}');
    //         },
    //         bottomNavigationBar: bottomNavigationBar,
    //         body: Padding(
    //           padding: const EdgeInsets.only(top: 8.0),
    //           child: Container(
    //             decoration: BoxDecoration(
    //               // color: Colors.black,
    //               color: backgroundColor ??
    //                   Theme.of(context).scaffoldBackgroundColor,
    //               borderRadius: BorderRadius.vertical(
    //                 top: Radius.circular(50.r),
    //               ),
    //             ),
    //             clipBehavior: Clip.antiAliasWithSaveLayer,
    //             child: Stack(
    //               alignment: Alignment.centerLeft,
    //               children: [
    //                 body,
    //                 if (isRulerOpen) rulerWidget,
    //               ],
    //             ),
    //           ),
    //         ),
    //         appBar: appBar,
    //         extendBody: extendBody,
    //         extendBodyBehindAppBar: extendBodyBehindAppBar,
    //         bottomSheet: bottomSheet,
    //         resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    //       )
    //     : Scaffold(
    //         backgroundColor: backgroundColor,
    //         floatingActionButtonLocation: floatingActionButtonLocation,
    //         floatingActionButton: floatingActionButton,
    //         drawer: drawer,
    //         onDrawerChanged: (value) {
    //           isRulerOpen = value;
    //           print('isRulerOpen ${isRulerOpen}');
    //         },
    //         bottomNavigationBar: bottomNavigationBar,
    //         body: Stack(
    //           alignment: Alignment.centerLeft,
    //           children: [
    //             body,
    //             if (isRulerOpen) rulerWidget,
    //           ],
    //         ),
    //         appBar: appBar,
    //         extendBody: extendBody,
    //         extendBodyBehindAppBar: extendBodyBehindAppBar,
    //         bottomSheet: bottomSheet,
    //         resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    //       );
  }
}
