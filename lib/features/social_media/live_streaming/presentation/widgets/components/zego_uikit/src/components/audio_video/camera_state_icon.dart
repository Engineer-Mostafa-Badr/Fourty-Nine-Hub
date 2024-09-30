// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import '../../../zego_uikit.dart';

/// monitor the camera status changes,
/// when the status changes, the corresponding icon is automatically switched
class ZegoCameraStateIcon extends ZegoServiceValueIcon {
  final ZegoUIKitUser? targetUser;

  final Image? iconCameraOn;
  final Image? iconCameraOff;

  ZegoCameraStateIcon({
    super.key,
    required this.targetUser,
    this.iconCameraOn,
    this.iconCameraOff,
  }) : super(
          notifier: ZegoUIKit().getCameraStateNotifier(targetUser?.id ?? ''),
          normalIcon: iconCameraOff ??
              UIKitImage.asset(StyleIconUrls.iconVideoViewCameraOff),
          checkedIcon: iconCameraOn ??
              UIKitImage.asset(StyleIconUrls.iconVideoViewCameraOn),
        );
}
