import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/meeting_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/meeting_state.dart';
import 'package:fourtyninehub/res/style/const.dart';

import '../../../../service_locator/service_locator.dart';
import '../../../social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';

class MeetingRoom extends StatefulWidget {
  const MeetingRoom(
      {super.key,
      required this.liveID,
      required this.isHost,
      this.shareScreen = false});

  final String liveID;
  final bool isHost;
  final bool shareScreen;

  @override
  State<MeetingRoom> createState() => _MeetingRoomState();
}

class _MeetingRoomState extends State<MeetingRoom> {
  @override
  void didChangeDependencies() {
    _turnOnShareScreenWhenJoining();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('live id is ${widget.liveID}');
    final String userId = context.read<UserCubit>().state.data!.id;
    final String userName = context.read<UserCubit>().state.data!.fullName;
    zegoUIKitPrebuiltLiveStreamingHostConfig() =>
        (ZegoUIKitPrebuiltLiveStreamingConfig.host()
          ..slideSurfaceToHide = false
          ..layout = ZegoLayout.pictureInPicture(
              // showScreenSharingFullscreenModeToggleButtonRules:
              //     ZegoShowFullscreenModeToggleButtonRules.alwaysShow,
              // showNewScreenSharingViewInFullscreenMode: false,
              )
          ..turnOnCameraWhenJoining = ZegoUIKit()
              .getCameraStateNotifier(ZegoUIKit().getLocalUser().id)
              .value
          //  Set the layout to gallery mode. and configure the [showNewScreenSharingViewInFullscreenMode] and [showScreenSharingFullscreenModeToggleButtonRules].
          ..swiping = null
          ..bottomMenuBar.showInRoomMessageButton = false);
    var zegoLayout = ZegoLayout.gallery(
        showScreenSharingFullscreenModeToggleButtonRules:
            ZegoShowFullscreenModeToggleButtonRules.alwaysShow,
        showNewScreenSharingViewInFullscreenMode: false);

    zegoUIKitPrebuiltLiveStreamingConfig() =>
        ZegoUIKitPrebuiltLiveStreamingConfig.audience()
          ..bottomMenuBar.showInRoomMessageButton = false
          ..layout =
              zegoLayout // Set the layout to gallery mode. and configure the [showNewScreenSharingViewInFullscreenMode] and [showScreenSharingFullscreenModeToggleButtonRules].
          ..turnOnCameraWhenJoining = ZegoUIKit()
              .getCameraStateNotifier(ZegoUIKit().getLocalUser().id)
              .value
          ..inRoomMessage.notifyUserJoin = true
          ..inRoomMessage.notifyUserJoin = false
          ..innerText.userEnter = 'Joined'
          ..innerText.userLeave = 'Left'
          ..video = ZegoUIKitVideoConfig.preset1080P()
          ..showBackgroundTips = true;

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
              userName: userName,
              liveID: widget.liveID,

              // Modify your custom configurations here.
              config: widget.isHost
                  ? zegoUIKitPrebuiltLiveStreamingHostConfig()
                  : zegoUIKitPrebuiltLiveStreamingConfig(),
            );
          },
        ),
      ),
    );
  }

  void _turnOnShareScreenWhenJoining() async {
    print('share screen mode');
    print('share screen mode ${widget.shareScreen}');
    if (widget.shareScreen) {
      await ZegoUIKit().startSharingScreen();
      ZegoUIKit().getScreenSharingStateNotifier().value = true;
    }
  }
}
