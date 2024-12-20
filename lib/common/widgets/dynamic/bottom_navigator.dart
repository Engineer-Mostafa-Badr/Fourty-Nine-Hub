import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/utils/handle_cashback.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:go_router/go_router.dart';

import '../../../routes/routes.dart';
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
        icon: FontAwesomeIcons.list,
        label: 'reels',
        index: 1,
        cacheKey: 'reelsCount',
        image: Assets.reels,
        route: Routes.REELS,
      ),
      BottomItemModel(
        icon: FontAwesomeIcons.bowlFood,
        label: 'meal',
        index: 0,
        cacheKey: 'mealsCount',
        image: Assets.food,
        route: Routes.FOOD,
      ),
      BottomItemModel(
        icon: FontAwesomeIcons.plus,
        // Change to a health-related icon
        label: 'health',
        cacheKey: 'healthCount',
        image: Assets.healthcare,
        index: 2,
        // Ensure this index matches the health item
        route: Routes.VISITA,
      ),
      BottomItemModel(
        icon: FontAwesomeIcons.car,
        label: 'ride',
        cacheKey: 'rideCount',
        index: 3,
        image: Assets.ride,
        route: Routes.RIDE,
      ),
    ];

    return CustomBottomNavigationBar(
      currentIndex: index,
      onTap: (index) {
        final selectedItem = pages[index];
        if (selectedItem.route != ModalRoute.of(context)?.settings.name) {
          selectedItem.action(context);
        }
        HandleCashback.setCount(pages[index].cacheKey ?? '', context);
      },
      items: pages,
      scrollController: scrollController,
      isScrollingDown: isScrollingDown,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
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

  double bottomNavBarHeight = 90.h; // Initial height of the bottom bar

  _CustomBottomNavigationBarState({
    required this.scrollController,
    required this.isScrollingDown,
  });

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          setState(() {
            isScrollingDown = true;
            bottomNavBarHeight = 0.0; // Hide the bottom bar
          });
        }
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          setState(() {
            isScrollingDown = false;
            bottomNavBarHeight = 90.h; // Show the bottom bar
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: bottomNavBarHeight, // Use the dynamic height
      child: CustomPaint(
        painter: BottomBarPainter(
          color: Colors.black,
        ),
        child: Container(
          padding: const EdgeInsets.only(bottom: 20, top: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(widget.items.length, (index) {
                  int index1 = context.isArabic ? 2 : 1;
                  int index2 = context.isArabic ? 1 : 2;

                  return GestureDetector(
                    onTap: () {
                      widget.onTap(index);
                    },
                    child: Padding(
                      padding: index == index1
                          ? EdgeInsets.only(right: 30.w)
                          : index == index2
                              ? EdgeInsets.only(left: 60.w)
                              : EdgeInsets.zero,
                      // Conditionally render the Icon or SvgPicture
                      child: index == 2 // Index for "health"
                          ? Image.asset(
                              widget.items[index].image!,
                              //width: 90.w,
                              height: widget.items[index].height * 2.h,
                            )
                          : SvgPicture.asset(
                              widget.items[index].image!,
                              height: widget.items[index].height * 1.8.h,
                            ),
                    ),
                  );
                }),
              ),
            ),
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
    this.height = 20,
  });

  void action(BuildContext context) {
    context.push(route);
  }
}
