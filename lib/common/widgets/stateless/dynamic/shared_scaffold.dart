import 'package:flutter/material.dart';

import '../../dynamic/drawer.dart';
import '../appbar/home_appbar.dart';

class SharedScaffold extends StatelessWidget {
  final int mainCategoryId;
  final Widget body;
  final bool extendBody;
  final Color? backgroundColor;
  final bool isWithBackArrow;
  const SharedScaffold(
      {super.key,
      required this.mainCategoryId,
      this.extendBody = false,
      this.isWithBackArrow = true,
      required this.body, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: extendBody,
      backgroundColor: backgroundColor,
      appBar:  HomeAppbar(
        isWithBackArrow: isWithBackArrow,
      ),
      drawer: const DrawerWidget(),
      // bottomNavigationBar: BottomNavigator(
      //   mainCategory: mainCategoryId,
      //   index: 2,
      //
      // ),
      // floatingActionButton: FloatingButton(
      //   changeView: mainCategoryId,
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: body,
    );
  }
}
