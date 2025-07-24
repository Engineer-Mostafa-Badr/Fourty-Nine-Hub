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
import '../../../features/ads_feature/ads/presentation/pages/ads_view.dart';
import '../../../features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../features/notifications/presentation/cubits/get_unread_notifications_count/get_unread_notifications_count_cubit.dart';
import '../../../features/notifications/presentation/widgets/icon_with_view_count.dart';
import '../../../res/style/app_colors.dart';
import '../../../res/style/styles.dart';
import '../../../routes/routes.dart';
import '../dialogs/please_login_dialog.dart';
import '../stateless/labels/label.dart';
import 'bottom_painter.dart';

class BottomNavigator extends StatelessWidget implements PreferredSizeWidget {
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
  Widget build(BuildContext context) {
    List<BottomItemModel> pages = <BottomItemModel>[
      BottomItemModel(
        icon: FontAwesomeIcons.bowlFood,
        label: LocaleKeys.ads.localize,
        index: 0,
        cacheKey: 'adCount',
        image: Assets.spcialAdsIcon,
        route: Routes.CREATECOMPANYAD,
      ),
      BottomItemModel(
        icon: FontAwesomeIcons.list,
        label: LocaleKeys.reels.localize,
        index: 1,
        cacheKey: 'reelsCount',
        image: Assets.reelBar,
        route: Routes.REELS,
      ),
      BottomItemModel(
        icon: FontAwesomeIcons.plus,
        // Change to a health-related icon
        label: LocaleKeys.health.localize,
        cacheKey: 'healthCount',
        image: Assets.health,
        index: 2,
        // Ensure this index matches the health item
        route: Routes.VISITA,
      ),
      BottomItemModel(
        icon: FontAwesomeIcons.plus,
        // Change to a health-related icon
        label: LocaleKeys.notifications.localize,
        cacheKey: 'notificationsCount',
        image: Assets.bell,
        index: 3,
        // Ensure this index matches the health item
        route: Routes.NOTIFICATIONS,
      ),
      BottomItemModel(
        icon: FontAwesomeIcons.car,
        label: LocaleKeys.more.localize,
        cacheKey: 'drawerCount',
        index: 4,
        image: Assets.menuSvg,
        route: Routes.RIDE_HOME,
      ),
    ];

    return CustomBottomNavigationBar(
      currentIndex: index,
      onTap: (index) {
        ManageVibration.vibrate();

        if (index == 4) {
          Scaffold.of(context).openDrawer();
        } else if (index == 0) {
          // soonDialog(context);
          context.push(pages[index].route);
        } else if (index == 3) {
          if (!context.read<UserCubit>().isLoggedIn) {
            return pleaseLoginDialog(context);
          }
          final selectedItem = pages[index];
          if (selectedItem.route != ModalRoute.of(context)?.settings.name) {
            selectedItem.action(context);
          }
          HandleCashback.setCount(pages[index].cacheKey ?? '', context);
        } else {
          final selectedItem = pages[index];
          if (selectedItem.route != ModalRoute.of(context)?.settings.name) {
            selectedItem.action(context);
          }
          HandleCashback.setCount(pages[index].cacheKey ?? '', context);
        }
      },
      items: pages,
      scrollController: scrollController,
      isScrollingDown: isScrollingDown,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(75);
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

  double bottomNavBarHeight = 75; // Initial height of the bottom bar
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
    // Check if the widget is disposed or not mounted before calling setState
    if (_isDisposed || !mounted) return;

    if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (!isScrollingDown && scrollController.offset > 20) {
        setState(() {
          isScrollingDown = true;
          bottomNavBarHeight = 0.0; // Hide the bottom bar
        });
      }
    } else if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (isScrollingDown) {
        setState(() {
          isScrollingDown = false;
          bottomNavBarHeight = 75; // Show the bottom bar
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 0),
      height: bottomNavBarHeight, // Use the dynamic height
      color: Colors.transparent,
      child: CustomPaint(
        painter: BottomBarPainter(
          color: Colors.transparent,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
            // padding: const EdgeInsets.only(bottom: 20, top: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 5, spreadRadius: 2),
              ],
            ),
            child:bottomNavBarHeight==75?Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(widget.items.length, (index) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (index != 2) {
                        widget.onTap(index);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsetsDirectional.zero,
                      child: isScrollingDown ? Container():ClickableWidget(
                        child: index == 3
                            ? Builder(
                                builder: (context) {
                                  final getUnreadNotificationsCountCubit =
                                      context.watch<
                                          GetUnreadNotificationsCountCubit>();
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CustomNotificationWidget(
                                        icon: Image.asset(
                                          Assets.notification,
                                          // height: widget.items[index].height,
                                          // width: widget.items[index].height - 4,
                                          color: context.isDarkMode
                                              ? Colors.white
                                              : AppColors.PRIMARY_COLOR,
                                        ),
                                        height: widget.items[index].height-5,
                                        unreadCount: !context
                                                .read<UserCubit>()
                                                .isLoggedIn
                                            ? 0
                                            : getUnreadNotificationsCountCubit
                                                    .unreadNotificationsCountEntity
                                                    ?.total ??
                                                0,
                                      ),
                                      Expanded(
                                        child: Label(
                                          text: widget.items[index].label,
                                          style: Styles.smallText(),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              )
                            : index != 2
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          widget.items[index].image!,
                                          height: widget.items[index].height,
                                          width: widget.items[index].height,
                                          color: context.isDarkMode
                                              ? Colors.white
                                              : AppColors.PRIMARY_COLOR,
                                        ),
                                        Label(
                                          text: widget.items[index].label,
                                          style: Styles.smallText(),
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
            ):Container(),
          ),
        ),
      ),
    );
  }
}

class BottomItemModel {
  final IconData icon;
  final String label;
  final int index;
  final String? image;
  final String? cacheKey;
  final String route;
  final double height;

  BottomItemModel({
    required this.icon,
    required this.label,
    required this.index,
    this.image,
    this.cacheKey,
    required this.route,
    this.height = 24,
  });

  void action(BuildContext context) {
    context.push(route);
  }
}
