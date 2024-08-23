// ignore_for_file: public_member_api_docs, sort_constructors_first
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
import 'member/button.dart';
import 'message/input_board_button.dart';

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
    var cameraDefaultOn = widget.config.turnOnCameraWhenJoining;
    var microphoneDefaultOn = widget.config.turnOnMicrophoneWhenJoining;
    final micState =
        ZegoUIKit().getMicrophoneStateNotifier(ZegoUIKit().getLocalUser().id);
    final cameraState =
        ZegoUIKit().getCameraStateNotifier(ZegoUIKit().getLocalUser().id);
    final screenShareState = ZegoUIKit().getScreenSharingStateNotifier();
    final needUserMuteMode =
        (!widget.config.coHost.stopCoHostingWhenMicCameraOff) ||
            ZegoLiveStreamingPKBattleStateCombineNotifier.instance.state.value;
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: widget.config.bottomMenuBar.margin,
        padding: widget.config.bottomMenuBar.padding,
        decoration: const BoxDecoration(
          color: Color(0xFF35383F),
        ),
        height: widget.config.bottomMenuBar.height ?? 120.zR,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            //mic
            ZoomMicrophoneBuilder(
              micState: micState,
              micDefaultOn: microphoneDefaultOn,
              needUserMuteMode: needUserMuteMode,
            ),
            //camera
            ZoomCameraBuilder(
              cameraState: cameraState,
              cameraDefaultOn: cameraDefaultOn,
            ),
            const VerticalDivider(
              color: Colors.white,
            ),
            ZoomParticipantsBuilder(
              widget: widget,
            ),
            ZoomChatBuilder(
              widget: widget,
            ),
            ZoomSharescreenBuilder(
              shareScreenState: screenShareState,
            ),
            ZoomShareCodeButton(
              liveId: ZegoUIKit().getRoom().id,
            ),
          ],
        ),
      ),
    );
  }
}

class ZoomMicrophoneBuilder extends StatelessWidget {
  const ZoomMicrophoneBuilder({
    super.key,
    required this.micState,
    required this.micDefaultOn,
    required this.needUserMuteMode,
  });

  final ValueNotifier<bool> micState;
  final bool micDefaultOn;
  final bool needUserMuteMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0).add(EdgeInsets.only(left: 5.zW)),
      child: ValueListenableBuilder<bool>(
          valueListenable: micState,
          builder: (context, micOn, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ZegoToggleMicrophoneButton(
                  buttonSize: Size(40.zW, 40.zH),
                  iconSize: const Size(100, 100),
                  normalIcon: ButtonIcon(
                    icon: const Icon(
                      Icons.mic,
                      color: Colors.white,
                      // size: 18.0,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  offIcon: ButtonIcon(
                    icon: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mic_off,
                          color: Colors.white,
                          // size: 18.0,
                        ),
                      ],
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  defaultOn: micDefaultOn,
                  muteMode: micDefaultOn,
                ),
                Text(
                  micState.value ? 'Mute' : 'Unmute',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20.zSP),
                )
              ],
            );
          }),
    );
  }
}

class ZoomCameraBuilder extends StatelessWidget {
  const ZoomCameraBuilder({
    super.key,
    required this.cameraState,
    required this.cameraDefaultOn,
  });

  final ValueNotifier<bool> cameraState;
  final bool cameraDefaultOn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0).add(EdgeInsets.only(left: 5.zW)),
      child: ValueListenableBuilder<bool>(
          valueListenable: cameraState,
          builder: (context, cameraOn, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ZegoToggleCameraButton(
                  buttonSize: Size(40.zW, 40.zH),
                  iconSize: const Size(100, 100),
                  normalIcon: ButtonIcon(
                    icon: const Icon(
                      Icons.videocam,
                      color: Colors.white,
                      // size: 18.0,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  offIcon: ButtonIcon(
                    icon: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.videocam_off,
                          color: Colors.white,
                          // size: 18.0,
                        ),
                      ],
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  defaultOn: cameraDefaultOn,
                ),
                Text(
                  cameraState.value ? 'Start Video' : 'Stop Video',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20.zSP),
                )
              ],
            );
          }),
    );
  }
}

class ZoomIconButtons {
  final Widget button;
  ZoomIconButtons({
    required this.button,
  });
}

class ZoomParticipantsBuilder extends StatelessWidget {
  final ZegoLiveStreamingBottomBar widget;
  const ZoomParticipantsBuilder({
    super.key,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0).add(EdgeInsets.only(left: 5.zW)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZegoLiveStreamingMemberButton(
            config: widget.config.memberList,
            events: widget.events.memberList,
            isCoHostEnabled: widget.isCoHostEnabled,
            hostManager: widget.hostManager,
            connectManager: widget.connectManager,
            popUpManager: widget.popUpManager,
            translationText: widget.translationText,
            builder: widget.config.memberButton.builder,
            icon: widget.config.memberButton.icon,
            backgroundColor: Colors.transparent,
            avatarBuilder: widget.config.avatarBuilder,
            itemBuilder: widget.config.memberList.itemBuilder,
          ),
          Text(
            'Participants',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 20.zSP),
          )
        ],
      ),
    );
  }
}

class ZoomChatBuilder extends StatelessWidget {
  final ZegoLiveStreamingBottomBar widget;
  const ZoomChatBuilder({
    super.key,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(3.0).add(EdgeInsets.only(left: 5.zW)),
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZegoLiveStreamingInRoomMessageInputBoardButton(
              translationText: widget.config.innerText,
              hostManager: widget.hostManager,
              onSheetPopUp: (int key) {
                widget.popUpManager.addAPopUpSheet(key);
              },
              onSheetPop: (int key) {
                widget.popUpManager.removeAPopUpSheet(key);
              },
              buttonSize: const Size(40, 40),
              iconSize: const Size(40, 40),
              enabledIcon: ButtonIcon(
                icon: Icon(
                  Icons.message_rounded,
                  color: Colors.white,
                  size: 30.zH,
                ),
              ),
            ),
            Positioned(
              bottom: 8.zH,
              right: 5,
              child: Text(
                'Chat',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 25.zSP),
              ),
            )
          ],
        ));
  }
}

class ZoomSharescreenBuilder extends StatelessWidget {
  const ZoomSharescreenBuilder({
    super.key,
    required this.shareScreenState,
  });

  final ValueNotifier<bool> shareScreenState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0).add(EdgeInsets.only(left: 5.zW)),
      child: ValueListenableBuilder<bool>(
          valueListenable: shareScreenState,
          builder: (context, screenShareOn, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ZegoScreenSharingToggleButton(
                  buttonSize: Size(35.zW, 35.zH),
                  // iconSize: const Size(120, 120),
                  iconStartSharing: ButtonIcon(
                    icon: const Icon(
                      Icons.screen_share_outlined,
                      color: Colors.green,
                      // size: 35,
                    ),
                  ),
                  iconStopSharing: ButtonIcon(
                    icon: const Icon(
                      Icons.stop_screen_share_outlined,
                      color: Colors.white,
                      // size: 35,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.zH),
                  child: Text(
                    !screenShareOn ? 'Share' : 'Stop Share',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 25.zSP),
                  ),
                )
              ],
            );
          }),
    );
  }
}

class ZoomShareCodeButton extends StatelessWidget {
  const ZoomShareCodeButton({super.key, required this.liveId});

  final String liveId;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: 8.0.zW),
        child: ZegoLiveStreamingMenuBarExtendButton(
            child: IconButton(
          icon: Icon(
            Icons.share,
            size: 35.zH,
            color: Colors.white,
          ),
          onPressed: () => Clipboard.setData(ClipboardData(text: liveId)).then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Live id Copied to clipboard $liveId'),
              ),
            ),
          ),
        )),
      ),
    );
  }
}
