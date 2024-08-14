import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/ride_request_view.dart';
import '../../../features/zoom/presentation/widgets/meeting_dialogue.dart';
import '../../../res/assets/assets.dart';
import '../../../routes/routes.dart';
import 'package:go_router/go_router.dart';

import 'bottom_painter.dart';

class BottomNavigator extends StatelessWidget implements PreferredSizeWidget {
  final int mainCategory;
  final int index;

  const BottomNavigator(
      {super.key, required this.mainCategory, required this.index});

  @override
  Widget build(BuildContext context) {
    List<BottomItemModel> pages = mainCategory == 3
        ? <BottomItemModel>[
            BottomItemModel(
                icon: FontAwesomeIcons.microphone,
                height: 30,
                label: 'Voice',
                index: 0,
                image: Assets.voiceLive,
                action: () => context.push(Routes.CLUBHOUSE)),
            BottomItemModel(
                icon: FontAwesomeIcons.stream,
                label: 'Live',
                index: 0,
                height: 25,
                image: Assets.live,
                action: () => context.push(Routes.LIVE)),
            BottomItemModel(
                icon: Icons.video_call,
                label: 'Meet',
                index: 0,
                height: 25,
                image: Assets.zoomMeeting,
                action: () => context.push(Routes.ZOOM)),
            BottomItemModel(
                icon: Icons.video_call,
                label: 'Cast',
                index: 0,
                height: 25,
                image: Assets.radio,
                action: () => context.push(Routes.CLUBHOUSE)),
          ]
        : mainCategory == 2
        ? <BottomItemModel>[
      BottomItemModel(
          icon: FontAwesomeIcons.twitter,
          label: 'tweet'.localize,
          index: 0,
          image: Assets.twitter,
          route: Routes.TWITTER),
      BottomItemModel(
          icon: FontAwesomeIcons.list,
          label: 'reels'.localize,
          index: 1,
          image: Assets.reels,
          route: Routes.REELS),
      BottomItemModel(
          icon: Icons.chat,
          label: 'chat'.localize,
          index: 3,
          image: Assets.message,
          route: Routes.CHAT),
      BottomItemModel(
          icon: FontAwesomeIcons.car,
          label: 'find'.localize,
          index: 4,
          image: Assets.social,
          route: Routes.Tinder),
    ]
        : <BottomItemModel>[
      BottomItemModel(
          icon: FontAwesomeIcons.bowlFood,
          label: 'meal'.localize,
          index: 0,
          image: Assets.food,
          route: Routes.FOOD),
      BottomItemModel(
          icon: FontAwesomeIcons.kitMedical,
          label: 'health'.localize,
          index: 1,
          image: Assets.health,
          route: Routes.VISITA),
      BottomItemModel(
          icon: Icons.delivery_dining,
          label: 'shipping'.localize,
          index: 3,
          image: Assets.shipping,
          route: Routes.SHIPPING),
      BottomItemModel(
          icon: FontAwesomeIcons.car,
          label: 'ride'.localize,
          index: 4,
          image: Assets.ride,
          route: Routes.RIDE),
    ];

    return CustomBottomNavigationBar(
      currentIndex: index,
      onTap: (index) {
        pages[index].action();
      },
      items: pages,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomItemModel> items;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  // late AnimationController _controller;
  // late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(
    //   duration: const Duration(milliseconds: 300),
    //   vsync: this,
    // );
    // _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BottomBarPainter(
        color: Colors.black,
      ),
      child: Container(
        padding: const EdgeInsets.only(bottom: 20, top: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2)
          ],
          // borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(widget.items.length, (index) {
              int index1= context.isArabic? 2:1;
              int index2= context.isArabic? 1:2;
                return GestureDetector(
                  onTap: () {
                    widget.onTap(index);
                  },
                  child: Padding(
                    padding: index == 1
                        ? const EdgeInsets.only(right: 10)
                        : index == 2
                            ? const EdgeInsets.only(left: 30)
                            : EdgeInsets.zero,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          widget.items[index].image,
                          height: widget.items[index].height,
                          semanticsLabel: widget.items[index].label,
                        ),
                        Text(
                          widget.items[index].label,
                          style: const TextStyle(color: Colors.black),
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
    required this.action,
    this.height = 20,
  });

  void action(BuildContext context) {
    context.push(route);
  }
}
