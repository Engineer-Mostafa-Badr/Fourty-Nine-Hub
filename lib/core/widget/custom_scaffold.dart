import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/dialogs/soon_dialog.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/utils/handle_cashback.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
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
    this.isMenu = false,
    this.resizeToAvoidBottomInset,
    this.scaffoldBackgroundWithAppBarColor,
    this.scaffoldKey,
  });

  final Widget body;
  final GlobalKey<ScaffoldState>? scaffoldKey;
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
  final bool? isMenu;
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
                drawer: widget.isMenu == false ? null : DrawerWidget(),
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
                  ManageVibration.vibrate();
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
    bool? isSvg = false,
    EdgeInsetsGeometry? padding,
    required void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 35.h,
        height: 35.h,
        padding: padding ?? const EdgeInsets.all(0),
        child: isSvg != true
            ? Image.asset(
                image,
                fit: BoxFit.cover,
                color: context.isDarkMode ? AppColors.whiteColor : null,
              )
            : SvgPicture.asset(
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
                            Row(
                              children: [
                                drawerRollWidget(
                                    image: Assets.quran,
                                    label: LocaleKeys.quraan.localize,
                                    onTap: () {
                                      ManageVibration.vibrate();
                                      floatingNavigatorCubit
                                          .changeFloatingNavigator();
                                      context.pushNamed(Routes.QURAAN);
                                    }),
                                SizedBox(
                                  width: 20,
                                ),
                                drawerRollWidget(
                                    image: Assets.azkar,
                                    label: LocaleKeys.azkar.localize,
                                    onTap: () {
                                      ManageVibration.vibrate();
                                      floatingNavigatorCubit
                                          .changeFloatingNavigator();
                                      context.pushNamed(Routes.AZKAAR);
                                    }),
                              ],
                            ),
                            Row(
                              children: [
                                drawerRollWidget(
                                    label: LocaleKeys.ride.localize,
                                    image: Assets.rideIcon,
                                    onTap: () {
                                      ManageVibration.vibrate();
                                      floatingNavigatorCubit
                                          .changeFloatingNavigator();
                                      context.pushNamed(Routes.RIDE_HOME);
                                    }),
                                SizedBox(
                                  width: 20,
                                ),
                                drawerRollWidget(
                                    label: LocaleKeys.tripJoin.localize,
                                    image: Assets.newTripJoin,
                                    onTap: () {
                                      ManageVibration.vibrate();
                                      HandleCashback.setCount(
                                          'tripJoinCount', context);
                                      floatingNavigatorCubit
                                          .changeFloatingNavigator();
                                      context.pushNamed(
                                          context.read<UserCubit>().isLoggedIn
                                              ? Routes.newRideModeScreen
                                              : Routes.FirstLoginScreen);
                                    }),
                              ],
                            ),
                            // drawerRollWidget(
                            //   label: LocaleKeys.loading.localize,
                            //   image: Assets.loading,
                            //   // onTap: () {},
                            //   onTap: () {
                            //     context.pop();
                            //     context
                            //         .push(Routes.createLoadingTripScreen);
                            //   },
                            // ),
                            Row(
                              children: [
                                drawerRollWidget(
                                  label: LocaleKeys.health.localize,
                                  image: Assets.healthIcon,
                                  onTap: () {
                                    ManageVibration.vibrate();
                                    floatingNavigatorCubit
                                        .changeFloatingNavigator();
                                    context.pushNamed(Routes.VISITA);
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                drawerRollWidget(
                                  label: LocaleKeys.meal.localize,
                                  image: Assets.meal,
                                  onTap: () {
                                    ManageVibration.vibrate();
                                    floatingNavigatorCubit
                                        .changeFloatingNavigator();
                                    context.pushNamed(Routes.FOOD);
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                drawerRollWidget(
                                  label: LocaleKeys.marriage.localize,
                                  image: Assets.married,
                                  onTap: () {
                                    ManageVibration.vibrate();
                                    floatingNavigatorCubit
                                        .changeFloatingNavigator();
                                    context.pushNamed(
                                        Routes.MARRIAGESUBCATEGORIES);
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                drawerRollWidget(
                                  label: LocaleKeys.tube.localize,
                                  image: Assets.tube1,
                                  onTap: () {
                                    ManageVibration.vibrate();
                                    HandleCashback.setCount(
                                        'beAStarCount', context);
                                    floatingNavigatorCubit
                                        .changeFloatingNavigator();
                                    context.pushNamed(Routes.BE_STAR);
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                drawerRollWidget(
                                  label: LocaleKeys.book.localize,
                                  image: Assets.booking,
                                  onTap: () {
                                    ManageVibration.vibrate();
                                    HandleCashback.setCount(
                                        'bookingCount', context);
                                    floatingNavigatorCubit
                                        .changeFloatingNavigator();
                                    soonDialog(context);
                                    // context.pushNamed(Routes.BE_STAR);
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                drawerRollWidget(
                                  label: LocaleKeys.find.localize,
                                  image: Assets.find,
                                  onTap: () {
                                    ManageVibration.vibrate();
                                    floatingNavigatorCubit
                                        .changeFloatingNavigator();
                                    context.pushNamed(Routes.Tinder);
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                drawerRollWidget(
                                  label: LocaleKeys.reel.localize,
                                  image: Assets.reel,
                                  onTap: () {
                                    ManageVibration.vibrate();
                                    floatingNavigatorCubit
                                        .changeFloatingNavigator();
                                    context.pushNamed(Routes.REELS);
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                drawerRollWidget(
                                  label: LocaleKeys.live.localize,
                                  image: Assets.liveIcon,
                                  onTap: () {
                                    ManageVibration.vibrate();
                                    floatingNavigatorCubit
                                        .changeFloatingNavigator();
                                    context.pushNamed(
                                        context.read<UserCubit>().isLoggedIn
                                            ? Routes.LIVE
                                            : Routes.FirstLoginScreen);
                                  },
                                ),
                              ],
                            ),
                            // drawerRollWidget(
                            //   label: LocaleKeys.meet.localize,
                            //   image: Assets.meet,
                            //   onTap: () {

                            //     context.pop();
                            //     context.pushNamed(Routes.MEETINGROOM);
                            //   },
                            // ),
                            // drawerRollWidget(
                            //   label: LocaleKeys.snap.localize,
                            //   image: Assets.snap,
                            //   onTap: () {
                            //     context.pop();
                            //     context.pushNamed(Routes.SNAP);
                            //   },
                            // ),
                            Row(
                              children: [
                                drawerRollWidget(
                                  label: LocaleKeys.chat.localize,
                                  image: Assets.whatsApp,
                                  onTap: () {
                                    ManageVibration.vibrate();
                                    floatingNavigatorCubit
                                        .changeFloatingNavigator();
                                    if (!context.read<UserCubit>().isLoggedIn)
                                      context
                                          .pushNamed(Routes.FirstLoginScreen);
                                    if (context.read<UserCubit>().isLoggedIn) {
                                      context.pushNamed(Routes.CHAT,
                                          extra: ChatsViewParams());
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                drawerRollWidget(
                                  label: context.isArabic ? 'العاب' : "Games",
                                  image: Assets.gamesIcon,
                                  onTap: () {
                                    ManageVibration.vibrate();
                                    floatingNavigatorCubit
                                        .changeFloatingNavigator();
                                    soonDialog(context);
                                    // context.pushNamed(Routes.CHAT,
                                    //     extra: ChatsViewParams());
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                drawerRollWidget(
                                  label: LocaleKeys.ads.localize,
                                  image: Assets.spcialAdsIcon,
                                  isSvg: true,
                                  onTap: () {
                                    ManageVibration.vibrate();
                                    floatingNavigatorCubit
                                        .changeFloatingNavigator();
                                    context.pushNamed(Routes.CREATECOMPANYAD);
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                drawerRollWidget(
                                  label:
                                      context.isArabic ? 'المزاد' : "Auction",
                                  image: Assets.bidIcon,
                                  onTap: () {
                                    ManageVibration.vibrate();
                                    floatingNavigatorCubit
                                        .changeFloatingNavigator();
                                    context.pushNamed(
                                        context.read<UserCubit>().isLoggedIn
                                            ? Routes.MAZADAT
                                            : Routes.FirstLoginScreen);
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                drawerRollWidget(
                                  label: LocaleKeys.chance.localize,
                                  image: Assets.chanceIcon,
                                  onTap: () {
                                    ManageVibration.vibrate();
                                    floatingNavigatorCubit
                                        .changeFloatingNavigator();
                                    context.pushNamed(
                                        context.read<UserCubit>().isLoggedIn
                                            ? Routes.CHANCE
                                            : Routes.FirstLoginScreen);
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                drawerRollWidget(
                                  label:
                                      context.isArabic ? 'عملات' : "Exchange",
                                  image: Assets.moneyExchange,
                                  onTap: () {
                                    ManageVibration.vibrate();
                                    floatingNavigatorCubit
                                        .changeFloatingNavigator();
                                    soonDialog(context);
                                  },
                                ),
                              ],
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
                    ManageVibration.vibrate();
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
              return Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Scaffold(
                    backgroundColor: backgroundColor,
                    floatingActionButtonLocation: floatingActionButtonLocation,
                    floatingActionButton: floatingActionButton,
                    drawer: drawer,
                    onDrawerChanged: (value) {
                      choiceRulerCubit.changeChoiceRulerStatus(
                          forceValue: !value);
                      print(
                          'choiceRulerCubit.state ${choiceRulerCubit.state} value $value');
                      print('onDrawerChanged open $value');
                    },
                    bottomNavigationBar: bottomNavigationBar,
                    body: body,
                    appBar: appBar,
                    extendBody: extendBody,
                    extendBodyBehindAppBar: extendBodyBehindAppBar,
                    bottomSheet: bottomSheet,
                    resizeToAvoidBottomInset: resizeToAvoidBottomInset,
                  ),
                  if ((choiceRulerCubit.choiceRulerStatus ||
                          floatingNavigatorCubit.floatingNavigatorStatus) &&
                      showNavBAr)
                    rulerWidget,
                ],
              );
            }
          },
        );
      },
    );
  }
}
