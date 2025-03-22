// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

// import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_bottom_navigator.dart';

import '../../../../../secrets/controller/secrets_cubit.dart';
import '../widgets/components/zego_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LiveStreamView extends StatefulWidget {
  final String liveID;
  final bool isHost;

  const LiveStreamView({
    super.key,
    required this.liveID,
    required this.isHost,
  });

  @override
  State<LiveStreamView> createState() => _LiveStreamViewState();
}

class _LiveStreamViewState extends State<LiveStreamView> {
  final liveStateNotifier = ValueNotifier<ZegoLiveStreamingState>(
    ZegoLiveStreamingState.idle,
  );

  @override
  Widget build(BuildContext context) {
    final hostConfig = ZegoUIKitPrebuiltLiveStreamingConfig.host(
      plugins: [ZegoUIKitSignalingPlugin()],
    )..layout = ZegoLayout.gallery();

    final audienceConfig = ZegoUIKitPrebuiltLiveStreamingConfig.audience(
      plugins: [ZegoUIKitSignalingPlugin()],
    )
      ..inRoomMessage = ZegoLiveStreamingInRoomMessageConfig(
          resendIcon: const Icon(
        Icons.reply,
        color: Colors.white,
      ))
      ..layout = ZegoLayout.gallery();

    final userId = context.read<UserCubit>().state.data!.id;
    print('live id is ${widget.liveID}');
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
          appID: context.read<SecretsCubit>().state.secrets!.zegoAppId,
          appSign: context.read<SecretsCubit>().state.secrets!.zegoAppSign,
          userID: userId,
          userName: context.read<UserCubit>().state.data!.fullName,
          liveID: widget.liveID,
          isLiveStream: true,
          config: widget.isHost ? hostConfig : audienceConfig
          // ..foreground = giftForeground()
          ),
    );
  }
}
