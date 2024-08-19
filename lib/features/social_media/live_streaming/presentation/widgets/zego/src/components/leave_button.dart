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
        /*/// prevent controller's leave function call after leave button click
        widget.isLeaveRequestingNotifier?.value = true;

        final endConfirmationEvent = ZegoLiveStreamingLeaveConfirmationEvent(
          context: context,
        );
        defaultAction() async {
          return widget.defaultLeaveConfirmationAction(endConfirmationEvent);
        }

        final canLeave = await widget.events.onLeaveConfirmation?.call(
              endConfirmationEvent,
              defaultAction,
            ) ??
            true;
        if (canLeave) {
          await notifyUserLeaveByMessage();

          if (widget.hostManager.isLocalHost) {
            /// live is ready to end, host will update if receive property notify
            /// so need to keep current host value, DISABLE local host value UPDATE
            widget.hostUpdateEnabledNotifier.value = false;
            ZegoUIKit().updateRoomProperties({
              RoomPropertyKey.host.text: '',
              RoomPropertyKey.liveStatus.text: LiveStatus.ended.index.toString()
            });
          }
        } else {
          /// restore controller's leave status
          widget.isLeaveRequestingNotifier?.value = false;
        }*/
        bool canLeave = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: Colors.white,
                title: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Colors.redAccent),
                    SizedBox(width: 10.zW),
                    const Text(
                      "Leave Meeting",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Are you sure you want to:",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.zSP,
                      ),
                    ),
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
                    SizedBox(height: 10.zH),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          // minimumSize: Size(MediaQuery.sizeOf(context).width*0.4,56.zH),
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.zR),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.zW, vertical: 10.zH),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
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
