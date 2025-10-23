import 'package:flutter/material.dart';

import '../../../../core/widget/custom_scaffold.dart';
import '../../dynamic/drawer.dart';
import '../appbar/home_appbar.dart';

class SharedScaffold extends StatelessWidget {
  final int mainCategoryId;
  final Widget body;
  final bool extendBody;
  final bool isWithBackArrow;
  final bool? resizeToAvoidBottomInset;
  final Color? backgroundColor;
  final Widget? floatingActionButton;
  final Function? onBackPressed;
  const SharedScaffold({
    super.key,
    required this.mainCategoryId,
    this.extendBody = false,
    this.isWithBackArrow = true,
    required this.body,
    this.onBackPressed,
    this.backgroundColor,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      key: key,
      extendBody: extendBody,
      backgroundColor: backgroundColor,
      drawer: const DrawerWidget(),
      body: body,
        resizeToAvoidBottomInset:resizeToAvoidBottomInset,
      appBar: PreferredSize(
        
        preferredSize: const Size.fromHeight(30),
        child: HomeAppbar(
          isWithBackArrow: isWithBackArrow,
          onBackPressed: onBackPressed,
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
