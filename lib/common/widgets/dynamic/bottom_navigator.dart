import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dialogs/soon_dialog.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/utils/handle_cashback.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/locale_keys.g.dart';
import '../../../features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../res/style/app_colors.dart';
import '../../../res/style/styles.dart';
import '../../../routes/routes.dart';
import '../dialogs/please_login_dialog.dart';
import '../stateless/labels/label.dart';
import 'bottom_painter.dart';

class BottomNavigator extends StatefulWidget implements PreferredSizeWidget {
  final int mainCategory;
  final int index;
  final ScrollController scrollController;
  final bool isScrollingDown;

  const BottomNavigator({
    super.key,
    required this.mainCategory,
    required this.index,
    required this.scrollController,
    required this.isScrollingDown,
  });

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();

  @override
  Size get preferredSize => const Size.fromHeight(75);
}

class _BottomNavigatorState extends State<BottomNavigator> {
  late PageController _pageController;
  Timer? _shuffleTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // Toggle between pages every 5 seconds
    _shuffleTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        _currentPage = _currentPage == 0 ? 1 : 0;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  List<BottomItemModel> firstPages = [
    BottomItemModel(
      icon: FontAwesomeIcons.bowlFood,
      localeKey: LocaleKeys.find,
      index: 0,
      cacheKey: 'tinderCount',
      image: Assets.find,
      route: Routes.Tinder,
    ),
    BottomItemModel(
      icon: FontAwesomeIcons.list,
      localeKey: LocaleKeys.reels,
      index: 1,
      cacheKey: 'reelsCount',
      image: Assets.reelBarPng,
      route: Routes.REELS,
    ),
    BottomItemModel(
      icon: FontAwesomeIcons.plus,
      localeKey: LocaleKeys.health,
      cacheKey: 'healthCount',
      image: Assets.health,
      index: 2,
      route: Routes.VISITA,
    ),
    BottomItemModel(
      icon: FontAwesomeIcons.plus,
      localeKey: LocaleKeys.chat,
      cacheKey: 'chatCount',
      image: Assets.whatsAppIcon,
      index: 3,
      height: 16,
      route: Routes.conversationsScreen,
    ),
    BottomItemModel(
      icon: FontAwesomeIcons.car,
      localeKey: LocaleKeys.chance,
      cacheKey: 'changeCount',
      index: 4,
      image: Assets.chanceIcon,
      route: Routes.CHANCE,
    ),
  ];

  List<BottomItemModel> secondPages = [
    BottomItemModel(
      icon: FontAwesomeIcons.bowlFood,
      localeKey: LocaleKeys.ride,
      index: 11,
      cacheKey: 'rideCount',
      image: Assets.rideIcon1,
      route: Routes.RIDE_HOME,
    ),
    BottomItemModel(
      icon: FontAwesomeIcons.plus,
      localeKey: LocaleKeys.tripJoin,
      cacheKey: 'tripJoinCount',
      image: Assets.tripJoinIcon2,
      index: 12,
      route: Routes.newRideModeScreen,
    ),
    BottomItemModel(
      icon: FontAwesomeIcons.plus,
      localeKey: LocaleKeys.health,
      cacheKey: 'healthCount',
      image: Assets.health,
      index: 13,
      route: Routes.VISITA,
    ),
    BottomItemModel(
      icon: FontAwesomeIcons.car,
      localeKey: LocaleKeys.meal,
      cacheKey: 'bookingCount',
      index: 14,
      image: Assets.mealIcon,
      route: Routes.FOOD,
    ),
    BottomItemModel(
      icon: FontAwesomeIcons.plus,
      localeKey: LocaleKeys.health,
      cacheKey: 'healthCount',
      image: Assets.healthIcon1,
      index: 15,
      route: Routes.VISITA,
    ),
  ];

  @override
  void dispose() {
    _shuffleTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: Column(
        children: [
          // Page indicators
          Container(
            height: 4,
            margin: EdgeInsets.symmetric(vertical: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: _currentPage == 0 
                        ? AppColors.PRIMARY_COLOR 
                        : Colors.grey.withOpacity(0.3),
                  ),
                ),
                SizedBox(width: 4.w),
                Container(
                  width: 8,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: _currentPage == 1 
                        ? AppColors.PRIMARY_COLOR 
                        : Colors.grey.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
          // PageView for bottom navigation
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                // First page
                CustomBottomNavigationBar(
                  currentIndex: widget.index,
                  onTap: (index) => _handleTap(firstPages[index], index),
                  items: firstPages,
                  scrollController: widget.scrollController,
                  isScrollingDown: widget.isScrollingDown,
                ),
                // Second page
                CustomBottomNavigationBar(
                  currentIndex: widget.index,
                  onTap: (index) => _handleTap(secondPages[index], index),
                  items: secondPages,
                  scrollController: widget.scrollController,
                  isScrollingDown: widget.isScrollingDown,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleTap(BottomItemModel item, int index) async {
    ManageVibration.vibrate();

    if (item.index == 4) {
      soonDialog(context);
    } else if (item.index == 0) {
      context.push(item.route);
    } else if (item.index == 3) {
      ManageVibration.vibrate();
      if (!context.read<UserCubit>().isLoggedIn) {
        return pleaseLoginDialog(context);
      }
      await context.read<UserCubit>().resetUnreadedChatsCounter();
      HandleCashback.setCount('chatCount', context);
      context.push(
        context.read<UserCubit>().isLoggedIn
            ? Routes.conversationsScreen
            : Routes.FirstLoginScreen,
      );
      HandleCashback.setCount(item.cacheKey ?? '', context);
    } else {
      final selectedItem = item;
      if (selectedItem.route != ModalRoute.of(context)?.settings.name) {
        selectedItem.action(context);
      }
      HandleCashback.setCount(item.cacheKey ?? '', context);
    }
  }
}

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomItemModel> items;
  final ScrollController scrollController;
  bool isScrollingDown;

  CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    required this.scrollController,
    required this.isScrollingDown,
  });

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState(
        scrollController: scrollController,
        isScrollingDown: isScrollingDown,
      );
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  final ScrollController scrollController;
  bool isScrollingDown;

  double bottomNavBarHeight = 75;
  bool _isDisposed = false;

  _CustomBottomNavigationBarState({
    required this.scrollController,
    required this.isScrollingDown,
  });

  @override
  void initState() {
    super.initState();
    isScrollingDown = widget.isScrollingDown;
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _isDisposed = true;
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_isDisposed || !mounted) return;

    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!isScrollingDown && scrollController.offset > 20) {
        setState(() {
          isScrollingDown = true;
          bottomNavBarHeight = 0.0;
        });
      }
    } else if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (isScrollingDown) {
        setState(() {
          isScrollingDown = false;
          bottomNavBarHeight = 75;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 0),
      height: bottomNavBarHeight,
      color: Colors.transparent,
      child: CustomPaint(
        painter: BottomBarPainter(color: Colors.transparent),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 5, spreadRadius: 2),
              ],
            ),
            child: bottomNavBarHeight == 75
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(widget.items.length, (index) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            ManageVibration.vibrate();
                            if (index != 2) {
                              widget.onTap(index);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsetsDirectional.zero,
                            child: isScrollingDown
                                ? Container()
                                : ClickableWidget(
                                    child: widget.items[index].index != 2 &&
                                            widget.items[index].index != 13
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16.0),
                                            child: Column(
                                              children: [
                                                (widget.items[index].index ==
                                                            3 ||
                                                        widget.items[index]
                                                                .index ==
                                                            4 ||
                                                        widget.items[index]
                                                                .index ==
                                                            0 ||
                                                        widget.items[index]
                                                                .index ==
                                                            12 ||
                                                        widget.items[index]
                                                                .index ==
                                                            11 ||
                                                        widget.items[index]
                                                                .index ==
                                                            15 ||
                                                        widget.items[index]
                                                                .index ==
                                                            14 ||
                                                        widget.items[index]
                                                                .index ==
                                                            1)
                                                    ? Image.asset(
                                                        widget.items[index]
                                                            .image!,
                                                        height: widget
                                                            .items[index]
                                                            .height-1,
                                                        width: widget
                                                            .items[index]
                                                            .height-1,
                                                        color: context
                                                                .isDarkMode
                                                            ? Colors.white
                                                            : AppColors
                                                                .PRIMARY_COLOR,
                                                      )
                                                    : SvgPicture.asset(
                                                        widget.items[index]
                                                            .image!,
                                                        height: widget
                                                            .items[index]
                                                            .height-1,
                                                        width: widget
                                                            .items[index]
                                                            .height-1,
                                                        color: context
                                                                .isDarkMode
                                                            ? Colors.white
                                                            : AppColors
                                                                .PRIMARY_COLOR,
                                                      ),
                                                if (widget.items[index].index ==
                                                    3)
                                                  SizedBox(
                                                    height: 2.h,
                                                  ),
                                                Expanded(
                                                  child: Label(
                                                    text: widget
                                                        .items[index]
                                                        .localeKey
                                                        .localize, // translate on build
                                                    style: Styles.smallText(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(),
                                  ),
                          ),
                        ),
                      );
                    }),
                  )
                : Container(),
          ),
        ),
      ),
    );
  }
}

class BottomItemModel {
  final IconData icon;
  final String localeKey; // store only key
  final int index;
  final String? image;
  final String? cacheKey;
  final String route;
  final double height;

  BottomItemModel({
    required this.icon,
    required this.localeKey,
    required this.index,
    this.image,
    this.cacheKey,
    required this.route,
    this.height = 20,
  });

  void action(BuildContext context) {
    context.push(route);
  }
}
