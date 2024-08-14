import 'package:flutter/material.dart';

import '../../dynamic/drawer.dart';
import '../appbar/home_appbar.dart';

class SharedScaffold extends StatelessWidget {
  final int mainCategoryId;
  final Widget body;
  final bool extendBody;
  final bool isWithBackArrow;
  final Color? backgroundColor;
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
      body: body,
    );
  }
}
