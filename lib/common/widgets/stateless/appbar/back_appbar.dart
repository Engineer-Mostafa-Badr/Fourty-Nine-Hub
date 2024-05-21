import 'package:flutter/material.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../labels/label.dart';

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool automaticallyImplyLeading;
  final String? label;
  final Color? backColor;
  final Color? iconColor;

  const BackAppBar({
    super.key,
    this.automaticallyImplyLeading = true,
    this.label,
    this.backColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: backColor ?? AppColors.LIGHT_COLOR,
      iconTheme: IconThemeData(color: iconColor ?? AppColors.PRIMARY_COLOR),
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: label != null
          ? Label(
              text: label ?? '',
              style: Styles.headerText(
                  color: iconColor ?? AppColors.PRIMARY_COLOR))
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
