import 'package:flutter/material.dart';

import '../../dynamic/bottom_navigator.dart';
import '../../dynamic/drawer.dart';
import '../../dynamic/floating_button.dart';
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
<<<<<<< HEAD
      appBar: HomeAppbar(
=======
      backgroundColor: backgroundColor,
      appBar:  HomeAppbar(
>>>>>>> f81a07431967fea988d5dd11b16e94cf604744ed
        isWithBackArrow: isWithBackArrow,
      ),
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
