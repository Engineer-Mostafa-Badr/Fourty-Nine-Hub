import 'package:flutter/material.dart';

import '../../../../core/widget/custom_scaffold.dart';
import '../../dynamic/drawer.dart';
import '../appbar/home_appbar.dart';

class SharedScaffold extends StatelessWidget {
  final int mainCategoryId;
  final Widget body;
  final bool extendBody;
  final bool isWithBackArrow;
  final Color? backgroundColor;
  final Widget? floatingActionButton;
  const SharedScaffold({
    super.key,
    required this.mainCategoryId,
    this.extendBody = false,
    this.isWithBackArrow = true,
    required this.body,
    this.backgroundColor,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      key: key,
      extendBody: extendBody,
      backgroundColor: backgroundColor,
      drawer: const DrawerWidget(),
      body: body,
      appBar: PreferredSize(
        
        preferredSize: const Size.fromHeight(30),
        child: HomeAppbar(
          isWithBackArrow: isWithBackArrow,
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
