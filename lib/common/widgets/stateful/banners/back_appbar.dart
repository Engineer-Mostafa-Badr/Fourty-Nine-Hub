import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../stateless/labels/label.dart';

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool automaticallyImplyLeading;
  final String? label;
  final Color? backColor;
  final Color? iconColor;
  final Color? textColor;
  final bool? centerTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool enableCustomAppBar;

  const BackAppBar({
    super.key,
    this.automaticallyImplyLeading = true,
    this.label,
    this.backColor,
    this.iconColor,
    this.actions,
    this.centerTitle = false,
    this.leading,
    this.textColor,
    this.enableCustomAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backColor ?? Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading ??
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              size: 40.w,
              color: enableCustomAppBar ? Colors.white : iconColor,
            ),
          ),
      title: label != null
          ? Label(
              text: label ?? '',
              style: Styles.headerText()
                  .copyWith(color: enableCustomAppBar ? Colors.white : textColor))
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
