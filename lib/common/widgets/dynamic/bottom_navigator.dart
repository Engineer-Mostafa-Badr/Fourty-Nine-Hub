import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:go_router/go_router.dart';

import '../../../res/assets/assets.dart';
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
    List<BottomItemModel> pages = mainCategory == 3
        ? <BottomItemModel>[
            BottomItemModel(
              icon: FontAwesomeIcons.microphone,
              height: 30,
              label: 'snap',
              // Translated text
              index: 0,
              image: Assets.cameraIcon,
              route: Routes.SNAP,
            ),
            BottomItemModel(
              icon: FontAwesomeIcons.stream,
              label: 'live',
              // Translated text
              index: 0,
              height: 25,
              image: Assets.live,
              route: Routes.LIVE,
            ),
            BottomItemModel(
              icon: Icons.video_call,
              label: 'meet',
              // Translated text
              index: 0,
              height: 25,
              image: Assets.zoomMeeting,
              route: Routes.ZOOM,
            ),
            BottomItemModel(
              icon: Icons.light_mode_rounded,
              label: 'spotlight',
              // Translated text
              index: 0,
              height: 25,
              image: Assets.spotlightIcon,
              route: Routes.SPOTLIGHT,
            ),
          ]
        : mainCategory == 2
            ? <BottomItemModel>[
                BottomItemModel(
                  icon: FontAwesomeIcons.twitter,
                  label: 'tweet',
                  // Translated text
                  index: 0,
                  image: Assets.twitter,
                  route: Routes.TWITTER,
                ),
                BottomItemModel(
                  icon: FontAwesomeIcons.list,
                  label: 'reels',
                  // Translated text
                  index: 1,
                  image: Assets.reels,
                  route: Routes.REELS,
                ),
                BottomItemModel(
                  icon: Icons.chat,
                  label: 'chat',
                  // Translated text
                  index: 3,
                  image: Assets.message,
                  route: Routes.CHAT,
                ),
                BottomItemModel(
                  icon: FontAwesomeIcons.car,
                  label: 'find',
                  // Translated text
                  index: 4,
                  image: Assets.social,
                  route: Routes.Tinder,
                ),
              ]
            : <BottomItemModel>[
                BottomItemModel(
                  icon: FontAwesomeIcons.bowlFood,
                  label: 'meal',
                  // Translated text
                  index: 0,
                  image: Assets.food,
                  route: Routes.FOOD,
                ),
                BottomItemModel(
                  icon: FontAwesomeIcons.kitMedical,
                  label: 'health',
                  // Translated text
                  index: 1,
                  image: Assets.health,
                  route: Routes.VISITA,
                ),
                BottomItemModel(
                  icon: Icons.delivery_dining,
                  label: 'ship',
                  // Using generated key for translation
                  index: 3,
                  image: Assets.shipping,
                  route: Routes.SHIPPING,
                ),
                BottomItemModel(
                  icon: FontAwesomeIcons.car,
                  label: 'ride',
                  // Using generated key for translation
                  index: 4,
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

  _CustomBottomNavigationBarState({
    required this.scrollController,
    required this.isScrollingDown,
  });

  @override
  void initState() {
    scrollController;
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          setState(() {
            isScrollingDown = true;
          });
        }
      } else {
        if (isScrollingDown) {
          setState(() {
            isScrollingDown = false;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (BuildContext context, Widget? child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          height: scrollController.position.userScrollDirection ==
                  ScrollDirection.reverse
              ? 0
              : 90.zH,
          child: CustomPaint(
            painter: BottomBarPainter(
              color: Colors.black,
            ),
            child: Container(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 5, spreadRadius: 2)
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
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
                              ? EdgeInsets.only(right: 30.zW)
                              : index == index2
                                  ? EdgeInsets.only(left: 60.zW)
                                  : EdgeInsets.zero,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: SvgPicture.asset(
                                  widget.items[index].image,
                                  height: widget.items[index].height * 1.8.zH,
                                  // color: context.read<ThemeCubit>().isDarkTheme
                                  //     ? Colors.white
                                  //     : null,
                                ),
                              ),
                            ],
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
      },
    );
  }
}

class BottomItemModel {
  final IconData icon;
  final String label;
  final int index;
  final String image;
  final String route;
  final double height;

  BottomItemModel({
    required this.icon,
    required this.label,
    required this.index,
    required this.image,
    required this.route,
    this.height = 20,
  });

  void action(BuildContext context) {
    context.push(route);
  }
}
