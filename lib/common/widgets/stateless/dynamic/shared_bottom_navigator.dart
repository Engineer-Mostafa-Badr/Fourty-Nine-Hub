import 'package:flutter/material.dart';

import '../../dynamic/bottom_navigator.dart';
import '../../dynamic/drawer.dart';
import '../../dynamic/floating_button.dart';
import '../appbar/home_appbar.dart';

class SharedCommonNavigator extends StatelessWidget {
  final int mainCategory;
  final Widget body;
  const SharedCommonNavigator(
      {super.key, required this.mainCategory, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppbar(),
      drawer: const DrawerWidget(),
      bottomNavigationBar: BottomNavigator(
        mainCategory: mainCategory,
        index: 1,
      ),
      floatingActionButton: const FloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: body,
    );
  }
}
