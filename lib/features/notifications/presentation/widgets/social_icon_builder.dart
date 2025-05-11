import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_unread_notifications_count/get_unread_notifications_count_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/icon_with_view_count.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../res/assets/assets.dart';

class SocialIconBuilder extends StatelessWidget {
  const SocialIconBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final getUnreadNotificationsCountCubit =
          context.watch<GetUnreadNotificationsCountCubit>();
      return CustomNotificationWidget(
        icon: SvgPicture.asset(
          Assets.social,
          height: 30,
          fit: BoxFit.cover,
          semanticsLabel: 'social',
          color: context.isDarkMode?AppColors.getRedColor(context):null,
        ),
        unreadCount: getUnreadNotificationsCountCubit
                .unreadNotificationsCountEntity?.socialCount ??
            0,
      );
    });
  }
}
