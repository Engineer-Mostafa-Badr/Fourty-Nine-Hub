import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class MeetingRoom extends StatelessWidget {
  const MeetingRoom({super.key, this.liveID = '123564564', this.isHost = true});

  final String liveID;
  final bool isHost;

  @override
  Widget build(BuildContext context) {
    final String userId = Random().nextInt(1000).toString();
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: UIConst.appId,
        appSign: UIConst.appSign,
        userID: userId,
        userName: 'user_$userId',
        liveID: liveID,

        // Modify your custom configurations here.
        config: isHost
            ? (ZegoUIKitPrebuiltLiveStreamingConfig.host()
                  ..layout = ZegoLayout.gallery(
                    showScreenSharingFullscreenModeToggleButtonRules:
                        ZegoShowFullscreenModeToggleButtonRules.alwaysShow,
                    showNewScreenSharingViewInFullscreenMode: false,
                  ) //  Set the layout to gallery mode. and configure the [showNewScreenSharingViewInFullscreenMode] and [showScreenSharingFullscreenModeToggleButtonRules].
                  ..bottomMenuBar =
                      ZegoLiveStreamingBottomMenuBarConfig(hostButtons: [
                    ZegoLiveStreamingMenuBarButtonName
                        .toggleScreenSharingButton,
                    ZegoLiveStreamingMenuBarButtonName.toggleMicrophoneButton,
                    ZegoLiveStreamingMenuBarButtonName.toggleCameraButton,
                    ZegoLiveStreamingMenuBarButtonName.switchCameraButton,
                  ]) // Add a screen sharing toggle button.
                )
            : (ZegoUIKitPrebuiltLiveStreamingConfig.audience()
              ..layout = ZegoLayout.gallery(
                  showScreenSharingFullscreenModeToggleButtonRules:
                      ZegoShowFullscreenModeToggleButtonRules.alwaysShow,
                  showNewScreenSharingViewInFullscreenMode:
                      false) // Set the layout to gallery mode. and configure the [showNewScreenSharingViewInFullscreenMode] and [showScreenSharingFullscreenModeToggleButtonRules].
              ..bottomMenuBar = ZegoLiveStreamingBottomMenuBarConfig(
                audienceButtons: [
                  ZegoLiveStreamingMenuBarButtonName.toggleScreenSharingButton,
                  ZegoLiveStreamingMenuBarButtonName.toggleMicrophoneButton,
                  ZegoLiveStreamingMenuBarButtonName.toggleCameraButton,
                  ZegoLiveStreamingMenuBarButtonName.switchCameraButton,
                  // ZegoLiveStreamingMenuBarButtonName.coHostControlButton,
                  // ZegoLiveStreamingMenuBarButtonName.minimizingButton,
                ],
              )
              ..topMenuBar = ZegoLiveStreamingTopMenuBarConfig(buttons: [
                ZegoLiveStreamingMenuBarButtonName.minimizingButton,

                // ZegoLiveStreamingMenuBarButtonName.beautyEffectButton
              ]) // Add a screen sharing toggle button.
            ),
      ),
    );
  }
}
