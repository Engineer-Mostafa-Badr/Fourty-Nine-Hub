
import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/dialogs/please_login_dialog.dart';
import '../../common/widgets/dynamic/drawer.dart';
import '../../common/widgets/stateless/labels/label.dart';
import '../../features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../features/settings/presentation/cubit/choice_ruler_cubit.dart';
import '../../features/settings/presentation/cubit/floating_navigator_cubit.dart';
import '../../features/social_media/chat/chat_view/presentation/pages/chats_view.dart';
import '../../main.dart';
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
    this.drawer = const DrawerWidget(),
    this.bottomNavigationBar,
    this.appBar,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.enableCustomAppBar = false,
    this.bottomSheet,
    this.showNavBAr = true,
    this.resizeToAvoidBottomInset,
    this.scaffoldBackgroundWithAppBarColor,
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
  final bool showNavBAr;
  final bool? resizeToAvoidBottomInset;
  final Widget? bottomSheet;
  final bool enableCustomAppBar;
  final Color? scaffoldBackgroundWithAppBarColor;

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold>
    with SingleTickerProviderStateMixin {
  // bool floatNavigator = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FloatingNavigatorCubit, FloatingNavigatorState>(
      builder: (context, state) {
        var floatingNavigatorCubit = FloatingNavigatorCubit.get(context);
        if (floatingNavigatorCubit.floatingNavigatorEnable &&
            widget.showNavBAr) {
          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: FloatingDraggableWidget(
              mainScreenWidget: MainScaffold(
                showNavBAr: widget.showNavBAr,
                backgroundColor: widget.backgroundColor,
                floatingActionButtonLocation:
                    widget.floatingActionButtonLocation,
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
                scaffoldBackgroundWithAppBarColor:
                    widget.scaffoldBackgroundWithAppBarColor,
              ),
              floatingWidget: GestureDetector(
                onTap: () {
                  floatingNavigatorCubit.changeFloatingNavigator();
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
                    SizedBox(
                      width: 32,
                      height: 28,
                      child: FittedBox(
                        child: Label(
                          text: LocaleKeys.move.localize,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              floatingWidgetHeight: 60,
              floatingWidgetWidth: 50,
              dy: MediaQuery.sizeOf(navigatorKey.currentState!.context).height /
                      2 +
                  100,
              autoAlign: true,
            ),
          );
        } else {
          return MainScaffold(
            showNavBAr: widget.showNavBAr,
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
            scaffoldBackgroundWithAppBarColor:
                widget.scaffoldBackgroundWithAppBarColor,
          );
        }
      },
    );
  }

  Widget drawerRollWidget({
    required String label,
    required String image,
    EdgeInsetsGeometry? padding,
    required void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.h,
        height: 40.h,
        padding: padding ?? const EdgeInsets.all(0),
        child: Image.asset(
          image,
          fit: BoxFit.cover,
          color: context.isDarkMode ? AppColors.whiteColor : null,
        ),
      ),
    );
  }

  Widget rulerWidget() {
    return BlocBuilder<FloatingNavigatorCubit, FloatingNavigatorState>(
      builder: (context, state) {
        var floatingNavigatorCubit = FloatingNavigatorCubit.get(context);
        return PositionedDirectional(
          start: 0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              floatingNavigatorCubit.floatingNavigatorStatus
                  ? Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadiusDirectional.horizontal(
                          end: Radius.circular(30.r),
                        ),
                        border: BorderDirectional(
                          end: BorderSide(
                            color: context.isDarkMode
                                ? Colors.white
                                : AppColors.PRIMARY_COLOR,
                            width: 2,
                          ),
                          top: BorderSide(
                            color: context.isDarkMode
                                ? Colors.white
                                : AppColors.PRIMARY_COLOR,
                            width: 2,
                          ),
                          bottom: BorderSide(
                            color: context.isDarkMode
                                ? Colors.white
                                : AppColors.PRIMARY_COLOR,
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
                              onTap: () {
                                floatingNavigatorCubit
                                    .changeFloatingNavigator();
                                context.push(Routes.RIDE_HOME);
                              },
                            ),
                            // drawerRollWidget(
                            //   label: LocaleKeys.loading.localize,
                            //   image: Assets.loading,
                            //   // onTap: () {},
                            //   onTap: () {
                            //     floatingNavigatorCubit.changeFloatingNavigator();
                            //     context.push(Routes.createLoadingTripScreen);
                            //   },
                            // ),
                            drawerRollWidget(
                              label: LocaleKeys.health.localize,
                              image: Assets.healthIcon,
                              onTap: () {
                                floatingNavigatorCubit
                                    .changeFloatingNavigator();
                                context.push(Routes.VISITA);
                              },
                            ),
                            drawerRollWidget(
                              label: LocaleKeys.meal.localize,
                              image: Assets.meal,
                              onTap: () {
                                floatingNavigatorCubit
                                    .changeFloatingNavigator();
                                context.push(Routes.FOOD);
                              },
                            ),
                            drawerRollWidget(
                              label: LocaleKeys.marriage.localize,
                              image: Assets.married,
                              onTap: () {
                                floatingNavigatorCubit
                                    .changeFloatingNavigator();
                                context.push(Routes.MARRIAGESUBCATEGORIES);
                              },
                            ),
                            drawerRollWidget(
                              label: LocaleKeys.find.localize,
                              image: Assets.find,
                              onTap: () {
                                floatingNavigatorCubit
                                    .changeFloatingNavigator();
                                context.push(Routes.Tinder);
                              },
                            ),
                            drawerRollWidget(
                              label: LocaleKeys.reel.localize,
                              image: context.isDarkMode ? Assets.reelBarPng : Assets.reel,
                              onTap: () {
                                floatingNavigatorCubit
                                    .changeFloatingNavigator();
                                context.push(Routes.REELS);
                              },
                            ),
                            drawerRollWidget(
                              label: LocaleKeys.spotlight.localize,
                              image: Assets.spotlight,
                              onTap: () {
                                floatingNavigatorCubit
                                    .changeFloatingNavigator();
                                if(!context.read<UserCubit>().isLoggedIn){
                                  return pleaseLoginDialog(context);
                                }
                                context.push(Routes.SPOTLIGHT);
                              },
                            ),
                            drawerRollWidget(
                              label: LocaleKeys.live.localize,
                              image: Assets.liveIcon,
                              onTap: () {

                                floatingNavigatorCubit
                                    .changeFloatingNavigator();
                                if(!context.read<UserCubit>().isLoggedIn){
                                  return pleaseLoginDialog(context);
                                }
                                context.push(Routes.LIVE);
                              },
                            ),
                            // drawerRollWidget(
                            //   label: LocaleKeys.snap.localize,
                            //   image: Assets.snap,
                            //   onTap: () {
                            //     floatingNavigatorCubit
                            //         .changeFloatingNavigator();
                            //     context.push(Routes.SNAP);
                            //   },
                            // ),
                            drawerRollWidget(
                              label: LocaleKeys.chat.localize,
                              image: Assets.whatsApp,
                              padding: const EdgeInsets.all(2),
                              onTap: () {
                                floatingNavigatorCubit
                                    .changeFloatingNavigator();
                                if(!context.read<UserCubit>().isLoggedIn){
                                  return pleaseLoginDialog(context);
                                }
                                context.push(Routes.CHAT,
                                    extra: ChatsViewParams());
                              },
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
                    floatingNavigatorCubit.changeFloatingNavigator();
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
                        color: AppColors.SECONDARY_COLOR,
                        border: BorderDirectional(
                          end: BorderSide(
                            color: context.isDarkMode
                                ? Colors.white
                                : AppColors.PRIMARY_COLOR,
                            width: 2,
                          ),
                          top: BorderSide(
                            color: context.isDarkMode
                                ? Colors.white
                                : AppColors.PRIMARY_COLOR,
                            width: 2,
                          ),
                          bottom: BorderSide(
                            color: context.isDarkMode
                                ? Colors.white
                                : AppColors.PRIMARY_COLOR,
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
      },
    );
  }
}

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    super.key,
    required this.body,
    this.backgroundColor,
    this.floatingActionButtonLocation,
    this.floatingActionButton,
    this.drawer,
    this.bottomNavigationBar,
    this.appBar,
    this.showNavBAr = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.enableCustomAppBar = false,
    this.bottomSheet,
    this.resizeToAvoidBottomInset,
    required this.rulerWidget,
    this.scaffoldBackgroundWithAppBarColor,
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
  final bool showNavBAr;
  final bool? resizeToAvoidBottomInset;
  final Widget? bottomSheet;
  final bool enableCustomAppBar;
  final Widget rulerWidget;
  final Color? scaffoldBackgroundWithAppBarColor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FloatingNavigatorCubit, FloatingNavigatorState>(
      builder: (context, state) {
        var floatingNavigatorCubit = FloatingNavigatorCubit.get(context);
        return BlocBuilder<ChoiceRulerCubit, ChoiceRulerState>(
          builder: (context, state) {
            var choiceRulerCubit = context.read<ChoiceRulerCubit>();
            if (enableCustomAppBar) {
              return Scaffold(
                backgroundColor: scaffoldBackgroundWithAppBarColor ??
                    AppColors.getButtonPrimaryColor(context),
                floatingActionButtonLocation: floatingActionButtonLocation,
                floatingActionButton: floatingActionButton,
                drawer: drawer,
                onDrawerChanged: (value) {
                  choiceRulerCubit.changeChoiceRulerStatus(forceValue: !value);

                  // choiceRulerCubit.changeChoiceRulerStatus();
                  print(
                      'choiceRulerCubit.state ${choiceRulerCubit.state} value $value');
                  print('onDrawerChanged open $value');
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
                        if ((choiceRulerCubit.choiceRulerStatus ||
                                floatingNavigatorCubit
                                    .floatingNavigatorStatus) &&
                            showNavBAr)
                          rulerWidget,
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
                  choiceRulerCubit.changeChoiceRulerStatus(forceValue: !value);
                  print(
                      'choiceRulerCubit.state ${choiceRulerCubit.state} value $value');
                  print('onDrawerChanged open $value');
                },
                bottomNavigationBar: bottomNavigationBar,
                body: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    body,
                    if ((choiceRulerCubit.choiceRulerStatus ||
                            floatingNavigatorCubit.floatingNavigatorStatus) &&
                        showNavBAr)
                      rulerWidget,
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
      },
    );
  }
}
