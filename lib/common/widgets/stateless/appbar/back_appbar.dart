import 'package:flutter/material.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../labels/label.dart';

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool automaticallyImplyLeading;
  final String? label;
  final Color? backColor;
  final Color? iconColor;
  final List<Widget>? actions;

  const BackAppBar({
    super.key,
    this.automaticallyImplyLeading = true,
    this.label,
    this.backColor,
    this.iconColor,
    this.actions
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: label != null
          ? Label(
              text: label ?? '',
              style: Styles.headerText())
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
