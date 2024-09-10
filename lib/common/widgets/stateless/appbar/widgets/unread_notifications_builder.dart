import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_unread_notifications_count/get_unread_notifications_count_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/icon_with_view_count.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

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
          icon: Image.asset(
            Assets.notification,
            width: 20,
            height: 20,
            fit: BoxFit.cover,
          ),
          unreadCount: getUnreadNotificationsCountCubit.unreadNotificationsCountEntity?.total ?? 0,
        );
      },
    );
  }
}
