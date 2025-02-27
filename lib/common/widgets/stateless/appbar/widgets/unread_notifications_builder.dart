import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_unread_notifications_count/get_unread_notifications_count_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/icon_with_view_count.dart';

import '../../../../../res/style/app_colors.dart';

class UnreadNotificationsBuilder extends StatelessWidget {
  const UnreadNotificationsBuilder({
    super.key,
    required this.inNotifications,
  });

  final bool inNotifications;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final getUnreadNotificationsCountCubit =
            context.watch<GetUnreadNotificationsCountCubit>();

        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: CustomNotificationWidget(
            icon: Icon(
              Icons.notifications,
              size: 45.w,
              color: inNotifications
                  ? AppColors.SECONDARY_COLOR
                  : context.isDarkMode
                      ? Colors.grey[200]
                      : Colors.black.withOpacity(0.8),
            ),
            // icon: Image.asset(
            //   Assets.notification,
            //   width: 30.h,
            //   height: 30.h,
            //   fit: BoxFit.cover,
            // ),

            unreadCount: getUnreadNotificationsCountCubit
                    .unreadNotificationsCountEntity?.total ??
                0,
          ),
        );
      },
    );
  }
}
