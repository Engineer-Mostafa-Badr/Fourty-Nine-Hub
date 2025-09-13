import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/icon_with_view_count.dart';

import '../../../../res/assets/assets.dart';

class StatusIconBuilder extends StatelessWidget {
  const StatusIconBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return CustomNotificationWidget(
        bottom: 25,
        start: 25,
        icon: Image.asset(
          context.isDarkMode ? Assets.status_dark : Assets.status,
          fit: BoxFit.fitWidth,
        ),
        unreadCount: 0,
      );
    });
  }
}
