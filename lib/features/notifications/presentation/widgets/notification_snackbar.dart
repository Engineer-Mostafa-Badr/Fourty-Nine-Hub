import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';

notificationSnackBar({
  required BuildContext context,
  required String title,
  required String body,
}) {
  ElegantNotification.success(
    title: Text(title),
    description: Text(body),
    onDismiss: () {},
    onNotificationPressed: () {},
    onCloseButtonPressed: () {},
  ).show(context);
}
