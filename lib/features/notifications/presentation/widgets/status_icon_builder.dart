import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_unread_notifications_count/get_unread_notifications_count_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/icon_with_view_count.dart';

import '../../../../res/assets/assets.dart';

class StatusIconBuilder extends StatelessWidget {
  const StatusIconBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final getUnreadNotificationsCountCubit =
          context.watch<GetUnreadNotificationsCountCubit>();
      return CustomNotificationWidget(
        icon: Image.asset(
          Assets.status,
          height: 30,
        ),
        //TODO Add request log count to backend
        unreadCount: getUnreadNotificationsCountCubit
                .unreadNotificationsCountEntity?.requestLogCount ??
            0,
      );
    });
  }
}
