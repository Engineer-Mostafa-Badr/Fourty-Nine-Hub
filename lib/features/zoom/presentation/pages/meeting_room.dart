import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/controller/stream_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/controller/stream_state.dart';
import 'package:fourtyninehub/secrets/controller/secrets_cubit.dart';

import '../../../social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class MeetingRoomArguments {
  final String liveID;
  final String userName;
  final bool isHost;
  final bool? shareScreen;

  MeetingRoomArguments(
      {required this.liveID,
      required this.userName,
      required this.isHost,
      this.shareScreen = false});
}

class MeetingRoom extends StatefulWidget {
  MeetingRoomArguments? args;
  MeetingRoom({super.key, payload}) {
    if (payload is MeetingRoomArguments) {
      args = payload;
    } else {
      args = MeetingRoomArguments(
        liveID: payload['room']['roomId'],
        userName: UserCubit.to.state.data?.firstName ?? '',
        isHost: true,
        shareScreen: false,
      );
    }
  }

  // final String liveID;
  // final String userName;
  // final bool isHost;
  // final bool shareScreen;

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
    // print('live id is ${widget.liveID}');
    final String userId = context.read<UserCubit>().state.data!.id;
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
      child: BlocBuilder<StreamCubit, StreamState>(
        builder: (context, state) {
          // var cubit = context.read<MeetingCubit>();
          return ZegoUIKitPrebuiltLiveStreaming(
            appID: context.read<SecretsCubit>().state.secrets!.zegoAppId,
            appSign: context.read<SecretsCubit>().state.secrets!.zegoAppSign,
            userID: userId,
            isLiveStream: false,
            userName: widget.args?.userName ?? '',
            liveID: widget.args?.liveID ?? '',

            // Modify your custom configurations here.
            config: widget.args?.isHost == true
                ? zegoUIKitPrebuiltLiveStreamingHostConfig()
                : zegoUIKitPrebuiltLiveStreamingConfig(),
          );
        },
      ),
    );
  }

  void _turnOnShareScreenWhenJoining() async {
    // print('share screen mode');
    // print('share screen mode ${widget.shareScreen}');
    if (widget.args?.shareScreen == true) {
      await ZegoUIKit().startSharingScreen();
      ZegoUIKit().getScreenSharingStateNotifier().value = true;
    }
  }
}
