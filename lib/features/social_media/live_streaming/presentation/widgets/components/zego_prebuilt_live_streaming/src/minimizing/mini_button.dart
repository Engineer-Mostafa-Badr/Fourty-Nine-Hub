// Flutter imports:
import 'package:flutter/material.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

// Package imports:

import '../../../zego_uikit/src/components/defines.dart';
import '../../../zego_uikit/src/components/theme.dart';
import '../../../zego_uikit/src/services/uikit_service.dart';
import '../components/defines.dart';
import '../controller.dart';
import '../internal/defines.dart';

// Project imports:

/// @nodoc
class ZegoLiveStreamingMinimizingButton extends StatefulWidget {
  const ZegoLiveStreamingMinimizingButton({
    super.key,
    this.afterClicked,
    this.icon,
    this.iconSize,
    this.buttonSize,
  });

  final ButtonIcon? icon;

  ///  You can do what you want after pressed.
  final VoidCallback? afterClicked;

  /// the size of button's icon
  final Size? iconSize;

  /// the size of button
  final Size? buttonSize;

  @override
  State<ZegoLiveStreamingMinimizingButton> createState() =>
      _ZegoLiveStreamingMinimizingButtonState();
}

/// @nodoc
class _ZegoLiveStreamingMinimizingButtonState
    extends State<ZegoLiveStreamingMinimizingButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final buttonSize = widget.buttonSize ?? zegoLiveButtonSize;
    final iconSize = widget.iconSize ?? zegoLiveButtonIconSize;

    return GestureDetector(
      onTap: () {
      ManageVibration.vibrate();
        if (ZegoUIKitPrebuiltLiveStreamingController().minimize.isMinimizing) {
          ZegoLoggerService.logInfo(
            'is minimizing, ignore',
            tag: 'live-streaming',
            subTag: 'overlay button',
          );

          return;
        }

        ZegoUIKitPrebuiltLiveStreamingController().minimize.minimize(context);

        if (widget.afterClicked != null) {
          widget.afterClicked!();
        }
      },
      child: Container(
        width: buttonSize.width,
        height: buttonSize.height,
        padding: EdgeInsets.all(buttonSize.width / 5),
        decoration: BoxDecoration(
          color: widget.icon?.backgroundColor ??
              ZegoUIKitDefaultTheme.buttonBackgroundColor,
          shape: BoxShape.circle,
        ),
        child: SizedBox.fromSize(
          size: iconSize,
          child: widget.icon?.icon ??
              ZegoLiveStreamingImage.asset(
                ZegoLiveStreamingIconUrls.minimizing,
              ),
        ),
      ),
    );
  }
}