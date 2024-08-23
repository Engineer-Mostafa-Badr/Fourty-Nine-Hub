// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/zoom_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/pages/meeting_view.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/components.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/core/connect_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/core/host_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/utils/pop_up_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/defines.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/inner_text.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/leave_button.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/config.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/events.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/events.defines.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/minimizing/mini_button.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';
import '../../../../../../../../res/assets/assets.dart';
import '../../../../../../../../res/style/app_colors.dart';

/// @nodoc
class ZegoLiveStreamingTopBar extends StatefulWidget {
  final bool isCoHostEnabled;
  final ZegoUIKitPrebuiltLiveStreamingConfig config;
  final ZegoUIKitPrebuiltLiveStreamingEvents events;
  final void Function(ZegoLiveStreamingEndEvent event) defaultEndAction;
  final Future<bool> Function(
    ZegoLiveStreamingLeaveConfirmationEvent event,
  ) defaultLeaveConfirmationAction;

  final ZegoLiveStreamingHostManager hostManager;
  final ValueNotifier<bool> hostUpdateEnabledNotifier;

  final ZegoLiveStreamingConnectManager connectManager;
  final ZegoLiveStreamingPopUpManager popUpManager;

  final ZegoUIKitPrebuiltLiveStreamingInnerText translationText;

  final ValueNotifier<bool>? isLeaveRequestingNotifier;
  final bool isLiveStream;

  const ZegoLiveStreamingTopBar({
    super.key,
    required this.isCoHostEnabled,
    required this.config,
    required this.events,
    required this.defaultEndAction,
    required this.defaultLeaveConfirmationAction,
    required this.hostManager,
    required this.hostUpdateEnabledNotifier,
    required this.connectManager,
    required this.popUpManager,
    required this.translationText,
    this.isLeaveRequestingNotifier,
    required this.isLiveStream,
  });

  @override
  State<ZegoLiveStreamingTopBar> createState() =>
      _ZegoLiveStreamingTopBarState();
}

/// @nodoc
class _ZegoLiveStreamingTopBarState extends State<ZegoLiveStreamingTopBar> {
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
      margin: widget.config.topMenuBar.margin,
      padding: widget.config.topMenuBar.padding,
      decoration: BoxDecoration(
        color: widget.config.topMenuBar.backgroundColor ?? Colors.transparent,
      ),
      height: widget.config.topMenuBar.height ?? 160.zH,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              topBarLeading(),
              // const Expanded(child: SizedBox()),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  Assets.logo,
                  height: 50.zH,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  minimizingButton(),
                  SizedBox(width: 20.zR),
                  if (widget.isLiveStream)
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
                      backgroundColor:
                          widget.config.memberButton.backgroundColor,
                      avatarBuilder: widget.config.avatarBuilder,
                      itemBuilder: widget.config.memberList.itemBuilder,
                    ),
                  SizedBox(width: 20.zW),
                  closeButton(),
                  SizedBox(width: 33.zW),
                ],
              ),
            ],
          ),
          const Divider()
        ],
      ),
    );
  }

  Widget minimizingButton() {
    return widget.config.topMenuBar.buttons
            .contains(ZegoLiveStreamingMenuBarButtonName.minimizingButton)
        ? ZegoLiveStreamingMinimizingButton(
            buttonSize: Size(52.zR, 52.zR),
            iconSize: Size(24.zR, 24.zR),
          )
        : Container();
  }

  Widget closeButton() {
    return widget.config.topMenuBar.showCloseButton
        ? ZegoLiveStreamingLeaveButton(
            // buttonSize: Size(52.zR, 52.zR),
            // iconSize: Size(24.zR, 24.zR),
            icon: ButtonIcon(
              icon: Center(
                child: Text(
                  widget.config.role == ZegoLiveStreamingRole.host
                      ? 'End'
                      : 'Leave',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              backgroundColor: Colors.red,
            ),
            config: widget.config,
            events: ZegoUIKitPrebuiltLiveStreamingEvents(),
            defaultEndAction: widget.defaultEndAction,
            defaultLeaveConfirmationAction:
                widget.defaultLeaveConfirmationAction,
            hostManager: widget.hostManager,
            hostUpdateEnabledNotifier: widget.hostUpdateEnabledNotifier,
            isLeaveRequestingNotifier: widget.isLeaveRequestingNotifier,
          )
        : Container();
  }

  Widget topBarLeading() {
    return ValueListenableBuilder<ZegoUIKitUser?>(
      valueListenable: widget.hostManager.notifier,
      builder: (context, host, _) {
        if (host == null) {
          return Container();
        }

        return Row(
          children: [
            SizedBox(width: 32.zR),
            //leave confirmation
            SizedBox(
              height: 68.zR,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pop(true);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.AUTH_CONTAINER_COLOR,
                ),
              ),
            ),
            SizedBox(width: 32.zR),
            ZegoSwitchAudioOutputButton(
              defaultUseSpeaker: widget.config.useSpeakerWhenJoining,
              speakerIcon: ButtonIcon(
                icon: widget.config.bottomMenuBar.buttonStyle
                    ?.switchAudioOutputToSpeakerButtonIcon,
              ),
              headphoneIcon: ButtonIcon(
                icon: widget.config.bottomMenuBar.buttonStyle
                    ?.switchAudioOutputToHeadphoneButtonIcon,
              ),
              bluetoothIcon: ButtonIcon(
                icon: widget.config.bottomMenuBar.buttonStyle
                    ?.switchAudioOutputToBluetoothButtonIcon,
              ),
            )
          ],
        );
      },
    );
  }

  void minimizeAndNavigate() {
    var cubit = context.read<MeetingCubit>();

    cubit.minimize();

    // Navigate to another screen after minimizing
    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MeetingView()),
      );
    });
  }
}
