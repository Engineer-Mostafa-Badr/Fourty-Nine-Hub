import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../stateless/labels/label.dart';

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool automaticallyImplyLeading;
  final String? label;
  final double? labelSize;
  final String? subTitle;
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
    this.subTitle, this.labelSize,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(

      backgroundColor: backColor ?? Colors.transparent,
      surfaceTintColor: backColor ?? Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading ??
          IconButton(
            onPressed: () {
      ManageVibration.vibrate();
              context.pop();
            },
            visualDensity: VisualDensity(horizontal: -4),
            icon: Icon(
              Icons.arrow_back,
              size: 40.w,
              color: enableCustomAppBar ? AppColors.getReversedTextColor(context) : iconColor,
            ),
          ),
      title: label != null
          ? Label(
              text: label ?? '',
              maxLines: 2,
              style: Styles.headerText(fontSize: labelSize??36).copyWith(
                  color: enableCustomAppBar ? AppColors.getReversedTextColor(context) : textColor))
          : null,
      actions: actions,
      bottom: subTitle?.isEmpty ?? true ? null : PreferredSize(
        preferredSize: const Size.fromHeight(16.0), // here the desired height
        child: Row(
          children: [
            const Sizer(width: 40,),
            Label(
                text: subTitle ?? '',
                style: Styles.mediumText().copyWith(
                    color: !enableCustomAppBar ? Colors.white : textColor)),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(30);
}
