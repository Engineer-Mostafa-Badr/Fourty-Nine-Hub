import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../features/custom_page/presentation/page/widget/custom_page_botton_nav_bar.dart';

class CustomBottomNavigator extends StatefulWidget {
  final int currentIndex;
  final ScrollController scrollController;
  final bool isScrollingDown;

  const CustomBottomNavigator(
      {super.key,
      required this.currentIndex,
      required this.scrollController,
      required this.isScrollingDown});

  @override
  State<CustomBottomNavigator> createState() => _CustomBottomNavigatorState(
        scrollController: scrollController,
        isScrollingDown: isScrollingDown,
      );
}

class _CustomBottomNavigatorState extends State<CustomBottomNavigator> {
  final ScrollController scrollController;
  bool isScrollingDown;

  _CustomBottomNavigatorState({
    required this.scrollController,
    required this.isScrollingDown,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedNotchBottomBar(
      notchBottomBarController:
          NotchBottomBarController(index: widget.currentIndex),
      bottomBarItems: const [
        BottomBarItem(
          inActiveItem: Icon(FontAwesomeIcons.car),
          activeItem: Text('car'),
        ),
        BottomBarItem(
          inActiveItem: Icon(FontAwesomeIcons.heart),
          activeItem: Text('heart'),
        ),
        BottomBarItem(
          inActiveItem: Icon(FontAwesomeIcons.headphones),
          activeItem: Text('headphones'),
        ),
      ],
      onTap: (int value) {
      },
      kIconSize: 25,
      kBottomRadius: 20,
    );
  }
}
