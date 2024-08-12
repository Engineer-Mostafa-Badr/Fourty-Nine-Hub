// ignore_for_file: public_member_api_docs, sort_constructors_first
// Flutter imports:
import 'package:flutter/material.dart';

import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/core/connect_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/core/host_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/utils/pop_up_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/defines.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/config.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/config.defines.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/events.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/events.defines.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/internal/defines.dart';

import '../inner_text.dart';
import '../internal/pk_combine_notifier.dart';

/// @nodoc
class ZegoLiveStreamingBottomBar extends StatefulWidget {
  final ZegoUIKitPrebuiltLiveStreamingConfig config;
  final ZegoUIKitPrebuiltLiveStreamingEvents events;
  final bool isLiveStream;
  final void Function(ZegoLiveStreamingEndEvent event) defaultEndAction;
  final Future<bool> Function(
    ZegoLiveStreamingLeaveConfirmationEvent event,
  ) defaultLeaveConfirmationAction;

  final Size buttonSize;

  final ZegoLiveStreamingHostManager hostManager;
  final ZegoLiveStreamingPopUpManager popUpManager;
  final ValueNotifier<bool> hostUpdateEnabledNotifier;

  final ValueNotifier<LiveStatus> liveStatusNotifier;
  final ZegoLiveStreamingConnectManager connectManager;

  final ValueNotifier<bool>? isLeaveRequestingNotifier;

  final bool isCoHostEnabled;
  final ZegoUIKitPrebuiltLiveStreamingInnerText translationText;

  const ZegoLiveStreamingBottomBar({
    super.key,
    required this.config,
    required this.events,
    required this.defaultEndAction,
    required this.defaultLeaveConfirmationAction,
    required this.buttonSize,
    required this.hostManager,
    required this.hostUpdateEnabledNotifier,
    required this.liveStatusNotifier,
    required this.connectManager,
    required this.popUpManager,
    this.isLeaveRequestingNotifier,
    required this.isLiveStream,
    required this.isCoHostEnabled,
    required this.translationText,
  });

  @override
  State<ZegoLiveStreamingBottomBar> createState() =>
      _ZegoLiveStreamingBottomBarState();
}

/// @nodoc
class _ZegoLiveStreamingBottomBarState
    extends State<ZegoLiveStreamingBottomBar> {
  List<ZegoLiveStreamingMenuBarButtonName> buttons = [];
  List<ZegoLiveStreamingMenuBarExtendButton> extendButtons = [];

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
      margin: widget.config.bottomMenuBar.margin,
      padding: widget.config.bottomMenuBar.padding,
      decoration: const BoxDecoration(
        color: Color(0xFF35383F),
      ),
      height: widget.config.bottomMenuBar.height ?? 120.zR,
      child: ListView.separated(
          itemCount: bottomBarIcons.length,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 5.zW,
            );
          },
          itemBuilder: (context, index) {
            final item = bottomBarIcons[index];
            return item.button;
          }),
    );
  }

  List<ZoomIconButtons> get bottomBarIcons {
    var cameraDefaultOn = widget.config.turnOnCameraWhenJoining;
    var microphoneDefaultOn = widget.config.turnOnMicrophoneWhenJoining;
    final needUserMuteMode =
        (!widget.config.coHost.stopCoHostingWhenMicCameraOff) ||
            ZegoLiveStreamingPKBattleStateCombineNotifier.instance.state.value;
    return [
      //mic
      ZoomIconButtons(
          button: ValueListenableBuilder<bool>(
              valueListenable: ZegoUIKit()
                  .getMicrophoneStateNotifier(ZegoUIKit().getLocalUser().id),
              builder: (context, isMuted, child) {
                return ZegoToggleMicrophoneButton(
                  buttonSize: const Size(100, 100),
                  iconSize: const Size(100, 100),
                  normalIcon: ButtonIcon(
                    icon: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.mic,
                          color: Colors.white,
                        ),
                        if (isMuted)
                          const Text(
                            'UnMute',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                      ],
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  offIcon: ButtonIcon(
                    icon: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.mic_off,
                          color: Colors.white,
                        ),
                        if (!isMuted)
                          const Text(
                            'Mute',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          )
                      ],
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  defaultOn: microphoneDefaultOn,
                  muteMode: needUserMuteMode,
                );
              }))
      //camera
      ,
      ZoomIconButtons(
          button: ValueListenableBuilder<bool>(
              valueListenable: ZegoUIKit()
                  .getCameraStateNotifier(ZegoUIKit().getLocalUser().id),
              builder: (context, videoOn, child) {
                return ZegoToggleCameraButton(
                  buttonSize: const Size(100, 100),
                  iconSize: const Size(100, 100),
                  normalIcon: ButtonIcon(
                    icon: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.videocam,
                          color: Colors.white,
                        ),
                        if (videoOn)
                          const Text(
                            'Start Video',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                      ],
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  offIcon: ButtonIcon(
                    icon: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.videocam_off,
                          color: Colors.white,
                        ),
                        if (!videoOn)
                          const Text(
                            'Stop Video',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          )
                      ],
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  defaultOn: false,
                );
              }))
    ];
  }
}

class ZoomIconButtons {
  final Widget button;
  ZoomIconButtons({
    required this.button,
  });
}
