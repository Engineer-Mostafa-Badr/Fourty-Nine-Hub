import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_states.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/bottom_painter.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';

class CustomPageBottonNavBar extends StatelessWidget
    implements PreferredSizeWidget {
  final int currentIndex;
  final ScrollController scrollController;
  final bool isScrollingDown;

  const CustomPageBottonNavBar({
    super.key,
    required this.currentIndex,
    required this.scrollController,
    required this.isScrollingDown,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomPageCubit>(
      create: (BuildContext context) => serviceLocator()..fetchNavigateBar(),
      child: BlocBuilder<CustomPageCubit, CustomPageState>(
        builder: (context, state) {
          // Check if navigateBar data is available
          if (state.navigateBar == null) {
            return const SizedBox(); // or a loading indicator
          }

          final navigateBar = state.navigateBar!;

          // Build the visible items based on the navigateBar properties
          List<BottomItemModel> visibleItems = [
            if (navigateBar.meal.enabled)
              BottomItemModel(
                icon: FontAwesomeIcons.bowlFood,
                label: 'meal',
                // Translated text
                image: Assets.food,
                route: Routes.FOOD,
              ),
            if (navigateBar.health.enabled)
              BottomItemModel(
                icon: FontAwesomeIcons.kitMedical,
                label: 'health',
                // Translated text
                image: Assets.health,
                route: Routes.VISITA,
              ),
            if (navigateBar.loading.enabled)
              BottomItemModel(
                icon: Icons.delivery_dining,
                label: 'ship',
                // Using generated key for translation
                image: Assets.shipping,
                route: Routes.SHIPPING,
              ),
            if (navigateBar.ride.enabled)
              BottomItemModel(
                icon: FontAwesomeIcons.car,
                label: 'ride',
                // Using generated key for translation
                image: Assets.ride,
                route: Routes.RIDE,
              ),
            // if (navigateBar.tweet)
            //   BottomItemModel(
            //     icon: FontAwesomeIcons.twitter,
            //     label: 'tweet',
            //     // Translated text
            //     image: Assets.twitter,
            //     route: Routes.TWITTER,
            //   ),
            if (navigateBar.reel.enabled)
              BottomItemModel(
                icon: FontAwesomeIcons.list,
                label: 'reels',
                // Translated text
                image: Assets.reels,
                route: Routes.REELS,
              ),
            // if (navigateBar.chat)
            //   BottomItemModel(
            //     icon: Icons.chat,
            //     label: 'chat',
            //     // Translated text
            //     image: Assets.message,
            //     route: Routes.CHAT,
            //   ),
            if (navigateBar.find.enabled)
              BottomItemModel(
                icon: FontAwesomeIcons.car,
                label: 'find',
                // Translated text
                image: Assets.social,
                route: Routes.Tinder,
              ),
            if (navigateBar.snap.enabled)
              BottomItemModel(
                icon: FontAwesomeIcons.microphone,
                label: 'snap',
                // Translated text
                image: Assets.cameraIcon,
                route: Routes.SNAP,
              ),
            if (navigateBar.live.enabled)
              BottomItemModel(
                icon: FontAwesomeIcons.stream,
                label: 'live',
                // Translated text
                image: Assets.live,
                route: Routes.LIVE,
              ),
            if (navigateBar.meet.enabled)
              BottomItemModel(
                icon: Icons.video_call,
                label: 'meet',
                // Translated text
                image: Assets.zoomMeeting,
                route: Routes.ZOOM,
              ),
            if (navigateBar.spotlight.enabled)
              BottomItemModel(
                icon: Icons.light_mode_rounded,
                label: 'spotlight',
                // Translated text
                image: Assets.spotlightIcon,
                route: Routes.SPOTLIGHT,
              ),
          ];

          return CustomBottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              final selectedItem = visibleItems[index];
              if (selectedItem.route != ModalRoute.of(context)?.settings.name) {
                selectedItem.action(context);
              }
              //HandleCashback.setCount(pages[index].cacheKey ?? '', context);
            },
            items: visibleItems,
            scrollController: scrollController,
            isScrollingDown: isScrollingDown,
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class BottomItemModel {
  final IconData icon;
  final String label;
  final String image;
  final String route;
  final double height;
  final bool isVisible; // New property to control visibility

  BottomItemModel({
    required this.icon,
    required this.label,
    required this.image,
    required this.route,
    this.height = 20,
    this.isVisible = true, // Default visibility is true
  });

  void action(BuildContext context) {
    context.push(route);
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
  // ignore: library_private_types_in_public_api
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
                  return GestureDetector(
                    onTap: () {
                      widget.onTap(index);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: SvgPicture.asset(
                            widget.items[index].image,
                            height: widget.items[index].height * 1.8.h,
                          ),
                        ),
                      ],
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
