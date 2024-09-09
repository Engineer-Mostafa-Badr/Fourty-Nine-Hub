import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/src/components/screen_util/core/size_extension.dart';

import '../../../../res/style/styles.dart';
import '../../stateless/labels/label.dart';

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool automaticallyImplyLeading;
  final String? label;
  final Color? backColor;
  final Color? iconColor;
  final bool? centerTitle;
  final List<Widget>? actions;

  const BackAppBar(
      {super.key,
      this.automaticallyImplyLeading = true,
      this.label,
      this.backColor,
      this.iconColor,
      this.actions,
      this.centerTitle = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            size: 40.zW,
          )),
      title: label != null
          ? Label(text: label ?? '', style: Styles.headerText())
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
