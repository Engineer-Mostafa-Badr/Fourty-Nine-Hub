// ignore_for_file: unused_import

import 'dart:math';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

notificationSnackBar({
  required BuildContext context,
  required NotificationEntity notificationEntity,
}) {
  String trimmedBody = notificationEntity.body ?? '';
  trimmedBody = trimmedBody.substring(0, min(trimmedBody.length, 30));
  showTopSnackBar(
    Overlay.of(context),
    GestureDetector(
      onTap: () {
        context.push(notificationEntity.path ?? '', extra: notificationEntity.payload);
      },
      child: CustomSnackBar.error(
        message: "${notificationEntity.title} \n${notificationEntity.body}",
        maxLines: 3,
      ),
    ),
  );
  // ElegantNotification.error(
  //   title: Text(
  //     notificationEntity.title ?? '',
  //     style: const TextStyle(color: AppColors.SECONDARY_COLOR),
  //   ),
  //   description: Text(
  //     trimmedBody,
  //   ),
  //   onDismiss: () {},
  //   onNotificationPressed: () {
  //     context.push(notificationEntity.path ?? '', extra: notificationEntity.payload);
  //   },
  //   onCloseButtonPressed: () {},
  //   toastDuration: const Duration(seconds: 7),
  // ).show(context);
}
