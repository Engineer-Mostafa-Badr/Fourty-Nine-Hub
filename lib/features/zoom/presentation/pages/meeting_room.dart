import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/zoom_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/zoom_state.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:go_router/go_router.dart';

import '../../../../service_locator/service_locator.dart';
import '../../../social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';

class MeetingRoom extends StatelessWidget {
  const MeetingRoom({super.key, required this.liveID, required this.isHost});

  final String liveID;
  final bool isHost;

  @override
  Widget build(BuildContext context) {
    print('live id is $liveID');
    final String userId = Random().nextInt(1000).toString();
    zegoUIKitPrebuiltLiveStreamingHostConfig(MeetingCubit cubit) =>
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
            _copyMeetingLiveIdExtendedButton(context),
            _endMeetingExtendedButton(context, cubit)
          ] // Add a screen sharing toggle button.
        );
    var zegoLayout = ZegoLayout.gallery(
        showScreenSharingFullscreenModeToggleButtonRules:
            ZegoShowFullscreenModeToggleButtonRules.alwaysShow,
        showNewScreenSharingViewInFullscreenMode: false);
    zegoLiveStreamingBottomMenuBarAudienceConfig(MeetingCubit cubit) =>
        ZegoLiveStreamingBottomMenuBarConfig(
          audienceButtons: [
            ZegoLiveStreamingMenuBarButtonName.toggleScreenSharingButton,
            ZegoLiveStreamingMenuBarButtonName.toggleMicrophoneButton,
            ZegoLiveStreamingMenuBarButtonName.toggleCameraButton,
            ZegoLiveStreamingMenuBarButtonName.switchCameraButton,
            // ZegoLiveStreamingMenuBarButtonName.coHostControlButton,
            // ZegoLiveStreamingMenuBarButtonName.minimizingButton,
          ],
        )..hostExtendButtons = [
            _copyMeetingLiveIdExtendedButton(context),
            _endMeetingExtendedButton(context, cubit)
          ];
    var zegoLiveStreamingTopMenuBarAudienceConfig =
        ZegoLiveStreamingTopMenuBarConfig(buttons: [
      // ZegoLiveStreamingMenuBarButtonName.minimizingButton,

      // ZegoLiveStreamingMenuBarButtonName.beautyEffectButton
    ]);

    zegoUIKitPrebuiltLiveStreamingConfig(MeetingCubit cubit) =>
        ZegoUIKitPrebuiltLiveStreamingConfig.audience()
          ..layout =
              zegoLayout // Set the layout to gallery mode. and configure the [showNewScreenSharingViewInFullscreenMode] and [showScreenSharingFullscreenModeToggleButtonRules].
          ..bottomMenuBar = zegoLiveStreamingBottomMenuBarAudienceConfig(cubit)
          ..topMenuBar = zegoLiveStreamingTopMenuBarAudienceConfig
          ..inRoomMessage.notifyUserJoin = true
          ..inRoomMessage.notifyUserJoin = false
          ..innerText.userEnter = 'Joined'
          ..innerText.userLeave = 'Left'
          ..video = ZegoUIKitVideoConfig.preset1080P()
          ..showBackgroundTips = true;
    print('live id is $liveID');
    return SafeArea(
      child: BlocProvider(
        create: (context) => serviceLocator<MeetingCubit>(),
        child: BlocBuilder<MeetingCubit, MeetingState>(
          builder: (context, state) {
            var cubit = context.read<MeetingCubit>();
            return ZegoUIKitPrebuiltLiveStreaming(
              appID: UIConst.appId,
              appSign: UIConst.appSign,
              userID: userId,
              isLiveStream: false,
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
                      ZegoUIKitPrebuiltLiveStreamingController()
                          .minimize
                          .hide();
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
                  ? zegoUIKitPrebuiltLiveStreamingHostConfig(cubit)
                  : zegoUIKitPrebuiltLiveStreamingConfig(cubit),
            );
          },
        ),
      ),
    );
  }

  ZegoLiveStreamingMenuBarExtendButton _endMeetingExtendedButton(
      BuildContext context, MeetingCubit cubit) {
    return ZegoLiveStreamingMenuBarExtendButton(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(40, 40),
              shape: const CircleBorder(),
              backgroundColor: const Color(0xff2C2F3E).withOpacity(0.6),
            ),
            child: const Icon(
              Icons.logout_outlined,
              size: 20,
              color: Colors.red,
            ),
            onPressed: () async {
              await endRoom(cubit);
              await kickAllUsersOut();
              if (context.mounted) {
                context.pop();
                context.pop();
              }
            }));
  }

  Future<void> kickAllUsersOut() async {
    final users = ZegoUIKit().getAllUsers();
    for (var user in users) {
      await ZegoUIKit().removeUserFromRoom([user.id]);
    }
  }

  Future<void> endRoom(MeetingCubit cubit) async => cubit.endRoom(liveID);

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
