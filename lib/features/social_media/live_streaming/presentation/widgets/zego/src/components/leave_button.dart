// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/minimizing/defines.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/controller.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/core/host_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/config.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/events.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/events.defines.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/internal/defines.dart';

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

  const ZegoLiveStreamingLeaveButton({
    super.key,
    required this.config,
    required this.events,
    required this.defaultEndAction,
    required this.defaultLeaveConfirmationAction,
    required this.hostManager,
    required this.hostUpdateEnabledNotifier,
    this.isLeaveRequestingNotifier,
    this.icon,
    this.iconSize,
    this.buttonSize,
  });

  @override
  State<ZegoLiveStreamingLeaveButton> createState() =>
      _ZegoLiveStreamingLeaveButtonState();
}

class _ZegoLiveStreamingLeaveButtonState
    extends State<ZegoLiveStreamingLeaveButton> {
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
      buttonSize: widget.buttonSize,
      iconSize: widget.iconSize,
      icon: widget.icon,
      clickableNotifier: hangupButtonClickableNotifier,
      onLeaveConfirmation: (context) async {
        bool canLeave = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                alignment: Alignment.topRight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: Colors.transparent,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10.zH),
                    if (widget.config.role == ZegoLiveStreamingRole.host)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                              MediaQuery.sizeOf(context).width * 0.4, 56.zH),
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.zR),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.zW, vertical: 10.zH),
                        ),
                        child: const Text("End Meeting for All"),
                        onPressed: () async {
                          final users = ZegoUIKit().getAllUsers();
                          for (var user in users) {
                            await ZegoUIKit().removeUserFromRoom([user.id]);
                          }
                          Navigator.of(context).pop(true);
                          Navigator.of(context).pop(true);
                          // widget.defaultEndAction;
                          // Add your logic to end the meeting for all participants here
                        },
                      ),
                    SizedBox(height: 10.zH),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.sizeOf(context).width * 0.4, 56.zH),
                        backgroundColor: Colors.orangeAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.zW, vertical: 10.zH),
                      ),
                      child: const Text("Just Leave the Meeting"),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        Navigator.of(context).pop(true);
                        // Add your logic to leave the meeting here
                        // widget.defaultEndAction;
                      },
                    ),
                    ],
                ),
              );
            });

        return canLeave;
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
    hangupButtonClickableNotifier.value =
        !(widget.isLeaveRequestingNotifier?.value ?? true);
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
