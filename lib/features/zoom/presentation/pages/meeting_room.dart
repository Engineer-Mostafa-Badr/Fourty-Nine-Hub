import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class MeetingRoom extends StatelessWidget {
  const MeetingRoom({super.key, required this.liveID, required this.isHost});

  final String liveID;
  final bool isHost;

  @override
  Widget build(BuildContext context) {
    final String userId = Random().nextInt(1000).toString();
    var zegoUIKitPrebuiltLiveStreamingHostConfig =
        (ZegoUIKitPrebuiltLiveStreamingConfig.host()
          ..layout = ZegoLayout.gallery(
            showScreenSharingFullscreenModeToggleButtonRules:
                ZegoShowFullscreenModeToggleButtonRules.alwaysShow,
            showNewScreenSharingViewInFullscreenMode: false,
          )
          //  Set the layout to gallery mode. and configure the [showNewScreenSharingViewInFullscreenMode] and [showScreenSharingFullscreenModeToggleButtonRules].
          ..bottomMenuBar = ZegoLiveStreamingBottomMenuBarConfig(
            hostButtons: [
              ZegoLiveStreamingMenuBarButtonName.toggleScreenSharingButton,
              ZegoLiveStreamingMenuBarButtonName.toggleMicrophoneButton,
              ZegoLiveStreamingMenuBarButtonName.toggleCameraButton,
              ZegoLiveStreamingMenuBarButtonName.switchCameraButton,
            ],
          )
          ..bottomMenuBar.hostExtendButtons = [
            _copyMeetingLiveIdExtendedButton(context)
          ] // Add a screen sharing toggle button.
        );
    var zegoLayout = ZegoLayout.gallery(
        showScreenSharingFullscreenModeToggleButtonRules:
            ZegoShowFullscreenModeToggleButtonRules.alwaysShow,
        showNewScreenSharingViewInFullscreenMode: false);
    var zegoLiveStreamingBottomMenuBarAudienceConfig =
        ZegoLiveStreamingBottomMenuBarConfig(
      audienceButtons: [
        ZegoLiveStreamingMenuBarButtonName.toggleScreenSharingButton,
        ZegoLiveStreamingMenuBarButtonName.toggleMicrophoneButton,
        ZegoLiveStreamingMenuBarButtonName.toggleCameraButton,
        ZegoLiveStreamingMenuBarButtonName.switchCameraButton,
        // ZegoLiveStreamingMenuBarButtonName.coHostControlButton,
        // ZegoLiveStreamingMenuBarButtonName.minimizingButton,
      ],
    )..hostExtendButtons = [_copyMeetingLiveIdExtendedButton(context)];
    var zegoLiveStreamingTopMenuBarAudienceConfig =
        ZegoLiveStreamingTopMenuBarConfig(buttons: [
      ZegoLiveStreamingMenuBarButtonName.minimizingButton,

      // ZegoLiveStreamingMenuBarButtonName.beautyEffectButton
    ]);

    var zegoUIKitPrebuiltLiveStreamingConfig =
        ZegoUIKitPrebuiltLiveStreamingConfig.audience()
          ..layout =
              zegoLayout // Set the layout to gallery mode. and configure the [showNewScreenSharingViewInFullscreenMode] and [showScreenSharingFullscreenModeToggleButtonRules].
          ..bottomMenuBar = zegoLiveStreamingBottomMenuBarAudienceConfig
          ..topMenuBar = zegoLiveStreamingTopMenuBarAudienceConfig
          ..inRoomMessage.notifyUserJoin = true
          ..inRoomMessage.notifyUserJoin = false
          ..innerText.userEnter = 'Joined'
          ..innerText.userLeave = 'Left'
          ..video = ZegoUIKitVideoConfig.preset1080P()
          ..showBackgroundTips = true;
          print('live id is $liveID');
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: UIConst.appId,
        appSign: UIConst.appSign,
        userID: userId,
        userName: 'user_$userId',
        liveID: liveID,

        /// to forcefully end meeting and dismiss all audience automatically the host ends live stream
        events: ZegoUIKitPrebuiltLiveStreamingEvents(
          onEnded: (
            ZegoLiveStreamingEndEvent event,
            VoidCallback defaultAction,
          ) {
            if (ZegoLiveStreamingEndReason.hostEnd == event.reason) {
              if (event.isFromMinimizing) {
                /// now is minimizing state, not need to navigate, just switch to idle
                ZegoUIKitPrebuiltLiveStreamingController().minimize.hide();
              } else {
                Navigator.pop(context);
              }
            } else {
              defaultAction.call();
            }
          },
        ),
        // Modify your custom configurations here.
        config: isHost
            ? zegoUIKitPrebuiltLiveStreamingHostConfig
            : zegoUIKitPrebuiltLiveStreamingConfig,
      ),
    );
  }

  ZegoLiveStreamingMenuBarExtendButton _copyMeetingLiveIdExtendedButton(
      BuildContext context) {
    return ZegoLiveStreamingMenuBarExtendButton(
        child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(40, 40),
        shape: const CircleBorder(),
        backgroundColor: const Color(0xff2C2F3E).withOpacity(0.6),
      ),
      child: const Icon(
        Icons.share,
        size: 20,
        color: Colors.white,
      ),
      onPressed: () => Clipboard.setData(ClipboardData(text: liveID)).then(
        (value) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Live id Copied to clipboard $liveID'),
          ),
        ),
      ),
    ));
  }
}
