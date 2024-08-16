import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import '../../../res/assets/assets.dart';
import '../../../routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../theme/cubit/cubit.dart';
import 'bottom_painter.dart';

class BottomNavigator extends StatelessWidget implements PreferredSizeWidget {
  final int mainCategory;
  final int index;

  const BottomNavigator({
    super.key,
    required this.mainCategory,
    required this.index
  });

  @override
  Widget build(BuildContext context) {

    List<BottomItemModel> pages = mainCategory == 3
        ? <BottomItemModel>[
      BottomItemModel(
          icon: FontAwesomeIcons.microphone,
          height: 30,
          label: 'voice'.localize,
          index: 0,
          image: Assets.voiceLive,
          route: Routes.CLUBHOUSE),
      BottomItemModel(
          icon: FontAwesomeIcons.stream,
          label: 'live'.localize,
          index: 0,
          height: 25,
          image: Assets.live,
          route: Routes.LIVE),
      BottomItemModel(
          icon: Icons.video_call,
          label: 'meet'.localize,
          index: 0,
          height: 25,
          image: Assets.zoomMeeting,
          route: Routes.ZOOM),
      BottomItemModel(
          icon: Icons.video_call,
          label: 'cast'.localize,
          index: 0,
          height: 25,
          image: Assets.radio,
          route: Routes.CLUBHOUSE),
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
          label: LocaleKeys.shipping.localize,
          index: 3,
          image: Assets.shipping,
          route: Routes.SHIPPING),
      BottomItemModel(
          icon: FontAwesomeIcons.car,
          label: LocaleKeys.ride.tr(),
          index: 4,
          image: Assets.ride,
          route: Routes.RIDE),
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
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BottomBarPainter(
        color: Colors.black,
      ),
      child: Container(
        padding: const EdgeInsets.only(bottom: 20, top: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2)
          ],
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
                    padding: index == index1
                        ? const EdgeInsets.only(right: 10)
                        : index == index2
                        ? const EdgeInsets.only(left: 30)
                        : EdgeInsets.zero,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          widget.items[index].image,
                          height: widget.items[index].height,
                          semanticsLabel: widget.items[index].label,
                          color:context.read<ThemeCubit>().isDarkTheme? Colors.white:null,
                        ),
                        Text(
                          widget.items[index].label,
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
    required this.route,
    this.height = 20,
  });

  void action(BuildContext context) {
    context.push(route);
  }
}
