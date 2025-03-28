// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/zego_uikit.dart';

/// Chat message list builder for customizing the display of chat messages.
typedef ZegoInRoomMessageItemBuilder = Widget Function(
  BuildContext context,
  ZegoInRoomMessage message,
  Map<String, dynamic> extraInfo,
);

typedef ZegoNotificationUserItemBuilder = Widget Function(
  BuildContext context,
  ZegoUIKitUser user,
  Map<String, dynamic> extraInfo,
);

typedef ZegoNotificationMessageItemBuilder = Widget Function(
  BuildContext context,
  ZegoInRoomMessage message,
  Map<String, dynamic> extraInfo,
);

enum NotificationItemType {
  userJoin,
  userLeave,
  message,
}
