import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget> actions;
  final double? size;
  final bool? showBack;
  final bool? centerTitle;

  const DefaultAppBar({
    super.key,
    required this.title,
    this.actions = const [],
    this.leading,
    this.size,
    this.showBack = true,
    this.centerTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color:
          context.isDarkMode ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: centerTitle ?? false,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
      backgroundColor: context.isDarkMode
          ? Colors.black
          : AppColors.PRIMARY_COLOR,
      elevation: 0,
      leadingWidth: showBack == true ? 30 : 10,
      leading: leading ??
          Visibility(
            visible: showBack ?? true,
            child: BackButton(
              onPressed: () {
                ManageVibration.vibrate();
                Navigator.pop(context);
              },
              color: context.isDarkMode ? Colors.black : Colors.white,
            ),
          ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(size ?? 50);
}
