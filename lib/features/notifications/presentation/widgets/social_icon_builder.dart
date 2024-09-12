import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_unread_notifications_count/get_unread_notifications_count_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/icon_with_view_count.dart';

import '../../../../res/assets/assets.dart';

class SocialIconBuilder extends StatelessWidget {
  const SocialIconBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final getUnreadNotificationsCountCubit = context.watch<GetUnreadNotificationsCountCubit>();
      return IconWithViewCount(
        icon: SvgPicture.asset(Assets.social, height: 20, semanticsLabel: 'social'),
        unreadCount: getUnreadNotificationsCountCubit.unreadNotificationsCountEntity?.socialCount ?? 0,
      );
    });
  }
}
