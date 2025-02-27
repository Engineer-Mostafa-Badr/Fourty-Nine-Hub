import 'package:flutter/material.dart';

import '../../../../core/widget/custom_scaffold.dart';
import '../../dynamic/bottom_navigator.dart';
import '../../dynamic/drawer.dart';
import '../../dynamic/floating_button.dart';
import '../appbar/home_appbar.dart';

class SharedCommonNavigator extends StatelessWidget {
  final int mainCategory;
  final Widget body;
  final bool showBottomNavigator;
  final bool showFloatingButton;
  const SharedCommonNavigator(
      {super.key,
      required this.mainCategory,
      required this.body,
      this.showBottomNavigator = true,
      this.showFloatingButton = true});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const HomeAppbar(),
      drawer: const DrawerWidget(),
      bottomNavigationBar: showBottomNavigator
          ? BottomNavigator(
              mainCategory: mainCategory,
              index: 1,
              scrollController: ScrollController(),
              isScrollingDown: false,
            )
          : null,
      floatingActionButton: showFloatingButton ? const FloatingButton() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: body,
    );
  }
}
