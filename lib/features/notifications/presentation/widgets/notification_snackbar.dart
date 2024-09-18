import 'dart:math';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

notificationSnackBar({
  required BuildContext context,
  required NotificationEntity notificationEntity,
}) {
  String trimmedBody = notificationEntity.body ?? '';
  trimmedBody = trimmedBody.substring(0, min(trimmedBody.length, 30));
  ElegantNotification.error(
    title: Text(
      notificationEntity.title ?? '',
      style: const TextStyle(color: AppColors.SECONDARY_COLOR),
    ),
    description: Text(
      trimmedBody,
    ),
    onDismiss: () {},
    onNotificationPressed: () {
      context.push(notificationEntity.path ?? '',
          extra: notificationEntity.payload);
    },
    onCloseButtonPressed: () {},
    toastDuration: const Duration(seconds: 7),
  ).show(context);
}
