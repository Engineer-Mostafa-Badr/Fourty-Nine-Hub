// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_audio_streaming/zego_uikit_prebuilt_live_audio_room.dart';

// Project imports:
import '../core/connect/connect_manager.dart';
import '../core/seat/seat_manager.dart';
import '../minimizing/mini_button.dart';
import 'defines.dart';
import 'leave_button.dart';

/// @nodoc
class ZegoLiveAudioRoomTopBar extends StatefulWidget {
  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;
  final ZegoUIKitPrebuiltLiveAudioRoomEvents events;
  final void Function(ZegoLiveAudioRoomEndEvent event) defaultEndAction;
  final Future<bool> Function(
    ZegoLiveAudioRoomLeaveConfirmationEvent event,
  ) defaultLeaveConfirmationAction;

  final ZegoLiveAudioRoomSeatManager seatManager;
  final ZegoLiveAudioRoomConnectManager connectManager;
  final ZegoUIKitPrebuiltLiveAudioRoomInnerText translationText;

  const ZegoLiveAudioRoomTopBar({
    super.key,
    required this.config,
    required this.events,
    required this.defaultEndAction,
    required this.defaultLeaveConfirmationAction,
    required this.seatManager,
    required this.connectManager,
    required this.translationText,
  });

  @override
  State<ZegoLiveAudioRoomTopBar> createState() =>
      _ZegoLiveAudioRoomTopBarState();
}

/// @nodoc
class _ZegoLiveAudioRoomTopBarState extends State<ZegoLiveAudioRoomTopBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      height: 80.zR,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          minimizingButton(),
          const Expanded(child: SizedBox()),
          closeButton(),
          SizedBox(width: 34.zR),
        ],
      ),
    );
  }

  Widget minimizingButton() {
    return widget.config.topMenuBar.buttons
            .contains(ZegoLiveAudioRoomMenuBarButtonName.minimizingButton)
        ? ZegoMinimizingButton(
            rootNavigator: widget.config.rootNavigator,
          )
        : Container();
  }

  Widget closeButton() {
    if (!widget.config.topMenuBar.showLeaveButton) {
      return Container();
    }

    return ZegoLiveAudioRoomLeaveButton(
      buttonSize: Size(52.zR, 52.zR),
      iconSize: Size(24.zR, 24.zR),
      icon: ButtonIcon(
        icon: ZegoLiveAudioRoomImage.asset(ZegoLiveAudioRoomIconUrls.topQuit),
        backgroundColor: Colors.white,
      ),
      config: widget.config,
      events: widget.events,
      defaultEndAction: widget.defaultEndAction,
      defaultLeaveConfirmationAction: widget.defaultLeaveConfirmationAction,
      seatManager: widget.seatManager,
    );
  }
}
