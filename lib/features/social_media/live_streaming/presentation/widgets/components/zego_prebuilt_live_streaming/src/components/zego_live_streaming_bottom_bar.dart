// ignore_for_file: public_member_api_docs, sort_constructors_first
// Flutter imports:
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/controller/tiktok_controller_extension.dart';
import 'package:fourtyninehub/features/zoom/presentation/controller/stream_cubit.dart';

// Project imports:
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/core/connect_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/core/host_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/components/utils/pop_up_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/defines.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/config.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/config.defines.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/events.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/events.defines.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/internal/defines.dart';

import '../../../../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../../../core/messages/messages.dart';
import '../inner_text.dart';
import '../internal/pk_combine_notifier.dart';
import 'live_page_surface.dart';
import 'member/button.dart';
import 'message/input_board_button.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/zego_uikit.dart';

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
    return !widget.isLiveStream
        ? _zoomBottomBar(
            micState,
            microphoneDefaultOn,
            needUserMuteMode,
            cameraState,
            cameraDefaultOn,
            screenShareState,
          )
        : Container(
            margin: widget.config.bottomMenuBar.margin,
            padding: widget.config.bottomMenuBar.padding,
            width: context.screenWidth,
            decoration: BoxDecoration(
              color: const Color(0xFF35383F).withOpacity(0.7),
            ),
            height: widget.config.bottomMenuBar.height ?? 120.zR,
            child: FakeTextFieldBuilder(widget: widget),
          );
  }

  Container _zoomBottomBar(
      ValueNotifier<bool> micState,
      bool microphoneDefaultOn,
      bool needUserMuteMode,
      ValueNotifier<bool> cameraState,
      bool cameraDefaultOn,
      ValueNotifier<bool> screenShareState) {
    return Container(
      margin: widget.config.bottomMenuBar.margin,
      padding: widget.config.bottomMenuBar.padding,
      decoration: const BoxDecoration(
        color: Color(0xFF35383F),
      ),
      height: widget.config.bottomMenuBar.height ?? 120.zR,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.zW),
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
            widgetBottom: widget,
          ),
          const Sizer(),
          ZoomChatBuilder(
            widget: widget,
          ),
          const Sizer(),
          ZoomSharescreenBuilder(
            shareScreenState: screenShareState,
          ),
          const Sizer(),
          ZoomWhiteBoardButton(
            config: widget.config,
          ),
          const Sizer(),
          ZoomShareCodeButton(
            liveId: ZegoUIKit().getRoom().id,
          ),
        ],
      ),
    );
  }
}

class FakeTextFieldBuilder extends StatelessWidget {
  const FakeTextFieldBuilder({
    super.key,
    required this.widget,
  });

  final ZegoLiveStreamingBottomBar widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        children: [

          Expanded(
            child: ZoomChatBuilder(
              widget: widget,
              child: ZegoLiveStreamingInRoomMessageInputBoardButton(
                  translationText: widget.config.innerText,
                  hostManager: widget.hostManager,
                  onSheetPopUp: (int key) {
                    widget.popUpManager.addAPopUpSheet(key);
                  },
                  onSheetPop: (int key) {
                    widget.popUpManager.removeAPopUpSheet(key);
                  },
                  buttonSize: Size(context.screenWidth * 0.8, 40),
                  iconSize: Size(context.screenWidth * 0.8, 40),
                  enabledIcon: ButtonIcon(
                      icon: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Label(
                        text: LocaleKeys.comment.localize,
                        color: Colors.grey,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ))),
            ),
          ),
          IconButton(onPressed: (){
            var cubit = context.read<StreamCubit>();
            cubit.requestBattle('6706b17a84a6fa95c2c0621b','66cc7223f3e66376f188c48b');
          }, icon: const Icon(Icons.person_2))
        ],
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
                    icon: Image.asset(
                      'assets/49-New-icons/mic.png',
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  offIcon: ButtonIcon(
                    icon: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/49-New-icons/mic_off.png',
                        )
                      ],
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  defaultOn: micDefaultOn,
                  muteMode: micDefaultOn,
                ),
                // Text(
                //   micState.value
                //       ? LocaleKeys.mute.localize
                //       : LocaleKeys.unmute.localize,
                //   style: TextStyle(
                //       color: Colors.white,
                //       fontWeight: FontWeight.w400,
                //       fontSize: 20.zSP),
                // )
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
                // Text(
                //   cameraState.value
                //       ? LocaleKeys.startVideo.localize
                //       : LocaleKeys.stopVideo.localize,
                //   style: TextStyle(
                //       color: Colors.white,
                //       fontWeight: FontWeight.w400,
                //       fontSize: 20.zSP),
                // )
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
  final ZegoLiveStreamingBottomBar? widgetBottom;
  final ZegoLiveStreamingLivePageSurface? widgetTop;

  const ZoomParticipantsBuilder({
    super.key,
    this.widgetBottom,
    this.widgetTop,
  }) : assert(widgetBottom == null || widgetTop == null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0).add(EdgeInsets.only(left: 5.zW)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widgetTop == null)
            ZegoLiveStreamingMemberButton(
              config: widgetBottom!.config.memberList,
              events: widgetBottom!.events.memberList,
              isCoHostEnabled: widgetBottom!.isCoHostEnabled,
              hostManager: widgetBottom!.hostManager,
              connectManager: widgetBottom!.connectManager,
              popUpManager: widgetBottom!.popUpManager,
              translationText: widgetBottom!.translationText,
              builder: widgetBottom!.config.memberButton.builder,
              icon: const Icon(Icons.person, color: Colors.white),
              backgroundColor: Colors.transparent,
              avatarBuilder: widgetBottom!.config.avatarBuilder,
              itemBuilder: widgetBottom!.config.memberList.itemBuilder,
            )
          else
            ZegoLiveStreamingMemberButton(
              config: widgetTop!.config.memberList,
              events: widgetTop!.events.memberList,
              isCoHostEnabled: true,
              hostManager: widgetTop!.hostManager,
              connectManager: widgetTop!.connectManager,
              popUpManager: widgetTop!.popUpManager,
              translationText: ZegoUIKitPrebuiltLiveStreamingInnerText(),
              builder: widgetTop!.config.memberButton.builder,
              icon: Image.asset('assets/49-New-icons/persons.png'),
              backgroundColor: Colors.transparent,
              avatarBuilder: widgetTop!.config.avatarBuilder,
              itemBuilder: widgetTop!.config.memberList.itemBuilder,
            ),
          // Text(
          //   LocaleKeys.participants.localize,
          //   style: TextStyle(
          //       color: Colors.white,
          //       fontWeight: FontWeight.w400,
          //       fontSize: 20.zSP),
          // )
        ],
      ),
    );
  }
}

class ZoomChatBuilder extends StatelessWidget {
  final ZegoLiveStreamingBottomBar widget;
  final Widget? child;

  const ZoomChatBuilder({
    super.key,
    required this.widget,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: child ??
          Padding(
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
                    buttonSize:  Size(50.zW, 35.zH),
                    iconSize:  Size(50.zW, 35.zH),
                    enabledIcon: ButtonIcon(
                        icon: Image.asset(
                      'assets/49-New-icons/chat.png',
                          height: 35.zH,
                          width: 50.zW,
                          fit: BoxFit.cover,
                    )),
                  ),
                  // Positioned(
                  //   bottom: 8.zH,
                  //   right: 5,
                  //   child: Text(
                  //     LocaleKeys.chat.localize,
                  //     style: TextStyle(
                  //         color: Colors.white,
                  //         fontWeight: FontWeight.w400,
                  //         fontSize: 25.zSP),
                  //   ),
                  // )
                ],
              )),
    );
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
    log('-------------${context.read<StreamCubit>().state}');
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0).add(EdgeInsets.only(left: 5.zW)),
        child: ValueListenableBuilder<bool>(
            valueListenable: shareScreenState,
            builder: (context, screenShareOn, child) {
              log('-------------$screenShareOn');
              if (!screenShareOn) {
                // context.read<StreamCubit>().closeWhiteBoard();
              }
              return ZegoScreenSharingToggleButton(
                buttonSize: Size(50.zW, 35.zH),
                iconSize:  Size(50.zW, 35.zH),
                iconStartSharing: ButtonIcon(
                  icon: Image.asset(
                    'assets/49-New-icons/sharescreen.png',
                    height: 35.zH,
                    width: 50.zW,
                    fit: BoxFit.cover,
                  ),
                ),
                iconStopSharing: ButtonIcon(
                  icon: const Icon(
                    Icons.stop_screen_share_outlined,
                    color: Colors.white,
                    // size: 35,
                  ),
                ),
              );
            }),
      ),
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
            size: 40.zH,
            color: Colors.white,
          ),
          onPressed: () => Clipboard.setData(ClipboardData(text: liveId)).then(
              (value) => showSuccessMessage(context,
                  '${LocaleKeys.roomCode.localize} \'$liveId ${LocaleKeys.copiedSuccessfully.localize}')),
        )),
      ),
    );
  }
}

class ZoomWhiteBoardButton extends StatelessWidget {
  final ZegoUIKitPrebuiltLiveStreamingConfig config;

  const ZoomWhiteBoardButton({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
            child: SvgPicture.asset(
              'assets/images/white_board.svg',
              height: 50.zH,
              width: 50.zW,
            ),
            onTap: () async {
              await context.read<StreamCubit>().openWhiteBoard();
            }),
        // Text(
        //   LocaleKeys.whiteBoard.localize,
        //   style: TextStyle(
        //     color: Colors.white,
        //     fontWeight: FontWeight.w400,
        //     fontSize: 25.zSP,
        //   ),
        // )
      ],
    );
  }
}
