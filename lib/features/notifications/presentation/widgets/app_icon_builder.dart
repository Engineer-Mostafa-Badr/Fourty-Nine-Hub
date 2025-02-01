import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_unread_notifications_count/get_unread_notifications_count_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/icon_with_view_count.dart';

import '../../../../res/assets/assets.dart';

class AppIconBuilder extends StatelessWidget {
  const AppIconBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final getUnreadNotificationsCountCubit =
          context.watch<GetUnreadNotificationsCountCubit>();
      return CustomNotificationWidget(
        icon: Image.asset(
          Assets.logo,
          height: 30.h,
        ),
        unreadCount: getUnreadNotificationsCountCubit
                .unreadNotificationsCountEntity?.appCount ??
            0,
      );
    });
  }
}
