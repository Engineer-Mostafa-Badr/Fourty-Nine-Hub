import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../res/style/styles.dart';

class IconWithViewCount extends StatelessWidget {
  const IconWithViewCount({
    super.key,
    required this.icon,
    required this.unreadCount,
  });
  final Widget icon;
  final int unreadCount;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, right: 15),
          child: Tab(
            icon: icon,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Text(
            unreadCount == 0 ? '   ' : '($unreadCount)',
            style: Styles.mediumText(color: AppColors.SECONDARY_COLOR),
          ),
        )
      ],
    );
  }
}
