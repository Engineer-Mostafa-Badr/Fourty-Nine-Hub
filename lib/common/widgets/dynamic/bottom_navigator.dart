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
                    label: 'Tweet',
                    index: 0,
                    image: Assets.twitter,
                    action: () => context.push(Routes.TWITTER)),
                BottomItemModel(
                    icon: FontAwesomeIcons.list,
                    label: 'Reels',
                    index: 1,
                    image: Assets.reels,
                    action: () => context.push(Routes.REELS)),
                BottomItemModel(
                    icon: Icons.chat,
                    label: 'Chat',
                    index: 3,
                    image: Assets.message,
                    action: () => context.push(Routes.CHAT)),
                BottomItemModel(
                    icon: FontAwesomeIcons.car,
                    label: 'Find',
                    index: 4,
                    image: Assets.social,
                    action: () => context.push(Routes.Tinder)),
              ]
            : <BottomItemModel>[
                BottomItemModel(
                    icon: FontAwesomeIcons.bowlFood,
                    label: 'Meal',
                    index: 0,
                    image: Assets.food,
                    action: () => context.push(Routes.FOOD)),
                BottomItemModel(
                    icon: FontAwesomeIcons.kitMedical,
                    label: 'Health',
                    index: 1,
                    image: Assets.health,
                    action: () => context.push(Routes.VISITA)),
                BottomItemModel(
                    icon: Icons.delivery_dining,
                    label: 'Shipping',
                    index: 3,
                    image: Assets.shipping,
                    action: () => context.push(Routes.SHIPPING)),
                BottomItemModel(
                    icon: FontAwesomeIcons.car,
                    label: 'Ride',
                    index: 4,
                    image: Assets.ride,
                    action: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RideRequestView()))),
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
                return GestureDetector(
                  onTap: () {
                    widget.onTap(index);
                  },
                  child: Padding(
                    padding: index == 3
                        ? const EdgeInsets.only(right: 10)
                        : index == 0
                            ? const EdgeInsets.only(left: 10)
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
  final Function action;
  final double height;
  BottomItemModel({
    required this.icon,
    required this.label,
    required this.index,
    required this.image,
    required this.action,
    this.height = 20,
  });
}
