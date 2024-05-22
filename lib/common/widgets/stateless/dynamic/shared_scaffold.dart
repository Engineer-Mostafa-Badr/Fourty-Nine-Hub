import 'package:flutter/material.dart';

import '../../dynamic/bottom_navigator.dart';
import '../../dynamic/drawer.dart';
import '../../dynamic/floating_button.dart';
import '../appbar/home_appbar.dart';

class SharedScaffold extends StatelessWidget {
  final int mainCategoryId;
  final Widget body;
  final bool extendBody;
  const SharedScaffold(
      {super.key, required this.mainCategoryId, 
      this.extendBody = false,
      required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: extendBody,
      appBar: const HomeAppbar(),
      drawer: const DrawerWidget(),
      bottomNavigationBar: BottomNavigator(
        mainCategory: mainCategoryId,
        index: 2,
      ),
      floatingActionButton: FloatingButton(
        changeView: mainCategoryId,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: body,
    );
  }
}
