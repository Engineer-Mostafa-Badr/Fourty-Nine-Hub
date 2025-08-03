import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

notificationSnackBar({
  required BuildContext context,
  required NotificationEntity notificationEntity,
  required bool isAppNotification,
}) {
  String trimmedBody = notificationEntity.body ?? '';
  trimmedBody = trimmedBody.substring(0, min(trimmedBody.length, 30));
  AudioPlayer player = AudioPlayer();
  player.play(AssetSource(isAppNotification
      ? Assets.notificationAudioApp
      : Assets.notificationAudioServieAndSocial));
  showTopSnackBar(
    Overlay.of(context),
    GestureDetector(
      onTap: () {
      ManageVibration.vibrate();
        context.push(notificationEntity.path ?? '',
            extra: notificationEntity.payload);
      },
      child: CustomSnackBar.error(
        message: "${notificationEntity.title} \n${notificationEntity.body}",
        maxLines: 3,
      ),
    ),
  );
}