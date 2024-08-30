// Flutter imports:
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/config.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/controller.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/core/host_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/events.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/events.defines.dart';
// Project imports:
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/minimizing/defines.dart';
// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

import '../defines.dart';

/// @nodoc
class ZegoLiveStreamingLeaveButton extends StatefulWidget {
  final ButtonIcon? icon;

  /// the size of button's icon
  final Size? iconSize;

  /// the size of button
  final Size? buttonSize;
  final ZegoUIKitPrebuiltLiveStreamingConfig config;
  final ZegoUIKitPrebuiltLiveStreamingEvents events;
  final void Function(ZegoLiveStreamingEndEvent event) defaultEndAction;
  final Future<bool> Function(
    ZegoLiveStreamingLeaveConfirmationEvent event,
  ) defaultLeaveConfirmationAction;

  final ZegoLiveStreamingHostManager hostManager;
  final ValueNotifier<bool> hostUpdateEnabledNotifier;
  final ValueNotifier<bool>? isLeaveRequestingNotifier;
  final ValueNotifier<bool> showTopBar;

  const ZegoLiveStreamingLeaveButton({
    super.key,
    required this.config,
    required this.events,
    required this.defaultEndAction,
    required this.defaultLeaveConfirmationAction,
    required this.hostManager,
    required this.hostUpdateEnabledNotifier,
    required this.showTopBar,
    this.isLeaveRequestingNotifier,
    this.icon,
    this.iconSize,
    this.buttonSize,
  });

  @override
  State<ZegoLiveStreamingLeaveButton> createState() => _ZegoLiveStreamingLeaveButtonState();
}

class _ZegoLiveStreamingLeaveButtonState extends State<ZegoLiveStreamingLeaveButton> {
  final hangupButtonClickableNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();

    widget.isLeaveRequestingNotifier?.addListener(oHangUpRequestingChanged);
  }

  @override
  void dispose() {
    widget.isLeaveRequestingNotifier?.removeListener(oHangUpRequestingChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ZegoLeaveButton(
      buttonSize: const Size(80, 40),
      iconSize: widget.iconSize,
      icon: widget.icon,
      clickableNotifier: hangupButtonClickableNotifier,
      onLeaveConfirmation: (context) async {
        widget.showTopBar.value = !widget.showTopBar.value;
        return false;
      },
      onPress: () async {
        final endEvent = ZegoLiveStreamingEndEvent(
          reason: widget.config.role == ZegoLiveStreamingRole.host
              ? ZegoLiveStreamingEndReason.hostEnd
              : ZegoLiveStreamingEndReason.localLeave,
          isFromMinimizing: ZegoLiveStreamingMiniOverlayPageState.minimizing ==
              ZegoUIKitPrebuiltLiveStreamingController().minimize.state,
        );
        defaultAction() {
          widget.defaultEndAction(endEvent);
        }

        if (widget.events.onEnded != null) {
          widget.events.onEnded!.call(endEvent, defaultAction);
        } else {
          defaultAction.call();
        }

        /// restore controller's leave status
        widget.isLeaveRequestingNotifier?.value = false;
      },
    );
  }

  void oHangUpRequestingChanged() {
    hangupButtonClickableNotifier.value = !(widget.isLeaveRequestingNotifier?.value ?? true);
  }

  Future<void> notifyUserLeaveByMessage() async {
    if (!widget.config.inRoomMessage.notifyUserLeave) {
      return;
    }

    final messageAttributes = widget.config.inRoomMessage.attributes?.call();
    if (messageAttributes?.isEmpty ?? true) {
      await ZegoUIKit().sendInRoomMessage(widget.config.innerText.userLeave);
    } else {
      await ZegoUIKit().sendInRoomMessage(
        ZegoInRoomMessage.jsonBody(
          message: widget.config.innerText.userLeave,
          attributes: messageAttributes!,
        ),
      );
    }
  }
}
