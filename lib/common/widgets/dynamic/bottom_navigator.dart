import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/ride_request_view.dart';
import 'sizer.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import '../../../res/assets/assets.dart';
import '../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../res/style/styles.dart';
import '../stateless/labels/label.dart';

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
                label: 'Voice',
                index: 0,
                image: Assets.voiceLive,
                action: () => context.push(Routes.CLUBHOUSE)),
            BottomItemModel(
                icon: FontAwesomeIcons.stream,
                label: 'Live',
                index: 0,
                image: Assets.live,
                action: () => context.push(Routes.LIVE)),
            BottomItemModel(
                icon: Icons.video_call,
                label: 'Meet',
                index: 0,
                image: Assets.zoomMeeting,
                action: () => context.push(Routes.MEETINGROOM)),
            BottomItemModel(
                icon: Icons.video_call,
                label: 'Broadcast',
                index: 0,
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
                // BottomItemModel(icon: FontAwesomeIcons.home, label: '', index: 2),
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
                // BottomItemModel(icon: FontAwesomeIcons.home, label: '', index: 2),
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
    return AnimatedBottomNavigationBar.builder(
        itemCount: pages.length,
        height: kToolbarHeight * .9,
        tabBuilder: (int index, bool isActive) {
          final item = pages[index];
          return Center(
            child: InkWell(
              onTap: () => item.action(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(item.image,
                      height: 20, semanticsLabel: item.label),
                  Label(text: item.label),
                ],
              ),
            ),
          );
        },
        activeIndex: 2,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge, // leftCornerRadius: 32,
        // rightCornerRadius: 0,
        onTap: (index) {});
    //other params
  }

  Widget button({required BottomItemModel item}) {
    return Expanded(
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              item.icon,
              color: Colors.white,
            ),
            const Sizer(
              height: 4,
            ),
            Label(
                text: item.label,
                style: Styles.mediumText(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget navigatorItem({required BottomItemModel item}) {
    return Expanded(
        child: Column(
      children: [
        Icon(item.icon),
        Label(
          text: item.label,
          style: Styles.mediumText(),
        )
      ],
    ));
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class BottomItemModel {
  final IconData icon;
  final String label;
  final int index;
  final String image;
  final Function action;

  BottomItemModel({
    required this.icon,
    required this.label,
    required this.index,
    required this.image,
    required this.action,
  });
}
