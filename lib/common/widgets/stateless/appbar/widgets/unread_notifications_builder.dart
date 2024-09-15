import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_unread_notifications_count/get_unread_notifications_count_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/icon_with_view_count.dart';

class UnreadNotificationsBuilder extends StatelessWidget {
  const UnreadNotificationsBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final getUnreadNotificationsCountCubit = context.watch<GetUnreadNotificationsCountCubit>();

        return IconWithViewCount(
          icon: Icon(Icons.notifications, size: 45.w, color: Colors.black.withOpacity(0.8)),
          // icon: Image.asset(
          //   Assets.notification,
          //   width: 30.h,
          //   height: 30.h,
          //   fit: BoxFit.cover,
          // ),
          spaceBetween: 0,
          unreadCount: getUnreadNotificationsCountCubit.unreadNotificationsCountEntity?.total ?? 0,
        );
      },
    );
  }
}
