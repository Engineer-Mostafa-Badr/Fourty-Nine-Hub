// Dart imports:
import 'dart:core';
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/components.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/effects/beauty_effect_button.dart';
// Project imports:
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/utils/permissions.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/utils/pop_up_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/core/host_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/internal/defines.dart';
// Package imports:
import 'package:permission_handler/permission_handler.dart';

import '../../zego_uikit_prebuilt_live_streaming.dart'; // import this

/// @nodoc
/// user should be login before page enter
class ZegoLiveStreamingPreviewPage extends StatefulWidget {
  const ZegoLiveStreamingPreviewPage({
    super.key,
    required this.appID,
    required this.appSign,
    required this.userID,
    required this.userName,
    required this.liveID,
    required this.hostManager,
    required this.startedNotifier,
    required this.liveStreamingPageReady,
    required this.config,
    required this.popUpManager,
    required this.kickOutNotifier,
    required this.isLiveStream,
  });

  final int appID;
  final String appSign;

  final String userID;
  final String userName;

  final String liveID;

  final ZegoLiveStreamingHostManager hostManager;
  final ValueNotifier<bool> startedNotifier;

  final ValueNotifier<bool> liveStreamingPageReady;

  final ZegoUIKitPrebuiltLiveStreamingConfig config;

  final ZegoLiveStreamingPopUpManager popUpManager;
  final ValueNotifier<bool> kickOutNotifier;

  /// to distinguesh between our [live] types
  final bool isLiveStream;

  @override
  State<ZegoLiveStreamingPreviewPage> createState() =>
      _ZegoLiveStreamingPreviewPageState();
}

/// @nodoc
class _ZegoLiveStreamingPreviewPageState
    extends State<ZegoLiveStreamingPreviewPage> {
  @override
  void initState() {
    super.initState();

    if (widget.config.turnOnCameraWhenJoining) {
      ZegoUIKit().turnCameraOn(widget.hostManager.isLocalHost);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLiveStream) {
      return zoomPreviewScreen(context);
    } else {
      return livePreviewScreen();
    }
  }

  Scaffold livePreviewScreen() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ZegoScreenUtilInit(
        designSize: const Size(750, 1334),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  background(constraints.maxHeight),
                  ZegoAudioVideoContainer(
                    layout: ZegoLayout.pictureInPicture(
                      smallViewPosition: ZegoViewPosition.bottomRight,
                      smallViewSize: Size(139.5.zW, 248.0.zH),
                      smallViewMargin: EdgeInsets.only(
                        left: 24.zR,
                        top: 144.zR,
                        right: 24.zR,
                        bottom: 144.zR,
                      ),
                    ),
                    foregroundBuilder: audioVideoViewForeground,
                    backgroundBuilder: audioVideoViewBackground,
                    avatarConfig: ZegoAvatarConfig(
                      showInAudioMode:
                          widget.config.audioVideoView.showAvatarInAudioMode,
                      showSoundWavesInAudioMode: widget
                          .config.audioVideoView.showSoundWavesInAudioMode,
                      builder: widget.config.avatarBuilder,
                    ),
                  ),
                  liveTopBar(),
                  bottomBar(),
                  foreground(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Scaffold zoomPreviewScreen(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xff2d2d2d),
      appBar: AppBar(
        // backgroundColor: const Color(0xff2d2d2d),
        centerTitle: true,
        leadingWidth: 80,
        elevation: 0,
        leading: TextButton(
          onPressed: () {
            Navigator.of(
              context,
              rootNavigator: widget.config.rootNavigator,
            ).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        title: const Text(
          'Start a meeting',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: ZegoScreenUtilInit(
        designSize: const Size(750, 1334),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  //background(constraints.maxHeight),
                  // ZegoAudioVideoContainer(
                  //   layout: ZegoLayout.pictureInPicture(
                  //     smallViewPosition: ZegoViewPosition.bottomRight,
                  //     smallViewSize: Size(139.5.zW, 248.0.zH),
                  //     smallViewMargin: EdgeInsets.only(
                  //       left: 24.zR,
                  //       top: 144.zR,
                  //       right: 24.zR,
                  //       bottom: 144.zR,
                  //     ),
                  //   ),
                  //   // foregroundBuilder: audioVideoViewForeground,
                  //   // backgroundBuilder: audioVideoViewBackground,
                  //   avatarConfig: ZegoAvatarConfig(
                  //     showInAudioMode:
                  //         widget.config.audioVideoView.showAvatarInAudioMode,
                  //     showSoundWavesInAudioMode: widget
                  //         .config.audioVideoView.showSoundWavesInAudioMode,
                  //     builder: widget.config.avatarBuilder,
                  //   ),
                  // ),
                  zoomTopBar(),
                  // foreground(
                  //   constraints.maxWidth,
                  //   constraints.maxHeight,
                  // ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget foreground(double width, double height) {
    return widget.config.foreground ?? Container();
  }

  Widget background(double height) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        width: 750.zW,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ZegoLiveStreamingImage.assetImage(
                ZegoLiveStreamingIconUrls.background),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget liveTopBar() {
    if (!widget.config.preview.topBar.isVisible) {
      return Container();
    }

    final buttonSize = Size(88.zR, 88.zR);
    final iconSize = Size(56.zR, 56.zR);

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
          left: 0.zR,
          top: 0,
          right: 10.zR,
          bottom: 0.zR,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                  color: const Color(0xFFED1C24),
                  borderRadius: BorderRadius.circular(15)),
              child: ZegoTextIconButton(
                onPressed: () {
                  Navigator.of(
                    context,
                    rootNavigator: widget.config.rootNavigator,
                  ).pop();
                },
                icon: ButtonIcon(
                  icon: widget.config.preview.pageBackIcon ??
                      (isRTL(context)
                          ? Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(math.pi),
                              child: ZegoLiveStreamingImage.asset(
                                ZegoLiveStreamingIconUrls.pageBack,
                              ),
                            )
                          : ZegoLiveStreamingImage.asset(
                              ZegoLiveStreamingIconUrls.pageBack,
                            )),
                ),
                iconSize: iconSize,
                buttonSize: buttonSize,
              ),
            ),
            const Expanded(child: SizedBox()),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              margin: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFFED1C24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ZegoSwitchCameraButton(
                    buttonSize: buttonSize,
                    iconSize: iconSize,
                    icon: ButtonIcon(
                      icon: const Icon(Icons.switch_camera, size: 20),
                      backgroundColor: Colors.transparent,
                    ),
                    defaultUseFrontFacingCamera: ZegoUIKit()
                        .getUseFrontFacingCameraStateNotifier(
                            ZegoUIKit().getLocalUser().id)
                        .value,
                  ),
                  ZegoToggleCameraButton(
                    buttonSize: buttonSize,
                    iconSize: iconSize,
                    normalIcon: ButtonIcon(
                        icon: const Icon(
                          Icons.videocam_outlined,
                          size: 20,
                        ),
                        backgroundColor: Colors.transparent),
                    offIcon: ButtonIcon(
                      icon: const Icon(
                        Icons.videocam_off_outlined,
                        size: 20,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  ZegoScreenSharingToggleButton(
                    buttonSize: buttonSize,
                    iconSize: iconSize,
                    iconStartSharing: ButtonIcon(
                      icon: const Icon(
                        Icons.screen_share_rounded,
                        size: 20,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    iconStopSharing: ButtonIcon(
                      icon: const Icon(
                        Icons.stop_screen_share_outlined,
                        size: 20,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  ZegoToggleMicrophoneButton(
                    buttonSize: buttonSize,
                    iconSize: iconSize,
                    normalIcon: ButtonIcon(
                      icon: const Icon(
                        Icons.mic,
                        size: 20,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    offIcon: ButtonIcon(
                      icon: const Icon(
                        Icons.mic_off_outlined,
                        size: 20,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget bottomBar() {
    if (!widget.config.preview.bottomBar.isVisible) {
      return Container();
    }

    final buttonSize = Size(88.zR, 88.zR);
    final iconSize = Size(56.zR, 56.zR);

    final beautyButtonPlaceHolder =
        SizedBox(width: buttonSize.width, height: buttonSize.height);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(
          left: 89.zR,
          top: 0,
          right: 89.zR,
          bottom: 97.zR,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.config.preview.bottomBar.showBeautyEffectButton
                ? ZegoLiveStreamingBeautyEffectButton(
                    translationText: widget.config.innerText,
                    rootNavigator: widget.config.rootNavigator,
                    effectConfig: widget.config.effect,
                    buttonSize: buttonSize,
                    iconSize: iconSize,
                    icon: widget.config.preview.beautyEffectIcon != null
                        ? ButtonIcon(
                            icon: widget.config.preview.beautyEffectIcon,
                          )
                        : null,
                  )
                : beautyButtonPlaceHolder,
            SizedBox(width: 48.zR),
            startButton(),
            SizedBox(width: 48.zR),
            beautyButtonPlaceHolder,
          ],
        ),
      ),
    );
  }

  Widget startButton() {
    print('tapped');
    final permissions = <Permission>[];
    if (widget.config.turnOnCameraWhenJoining) {
      permissions.add(Permission.camera);
    }
    if (widget.config.turnOnMicrophoneWhenJoining) {
      permissions.add(Permission.microphone);
    }

    defaultAction() async {
      await checkPermissions(
        context: context,
        permissions: permissions,
        isShowDialog: true,
        translationText: widget.config.innerText,
        rootNavigator: widget.config.rootNavigator,
        popUpManager: widget.popUpManager,
        kickOutNotifier: widget.kickOutNotifier,
      ).then(
        (value) {
          if (!widget.liveStreamingPageReady.value) {
            ZegoLoggerService.logInfo(
              'live streaming page is waiting room login',
              tag: 'live-streaming',
              subTag: 'preview page',
            );
            return;
          }

          widget.startedNotifier.value = true;
        },
      );
    }

    return widget.config.preview.startLiveButtonBuilder?.call(context,
            () async {
          defaultAction.call();
        }) ??
        GestureDetector(
          onTap: defaultAction,
          child: Container(
            width: 300.zR,
            height: 88.zR,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(44.zR),
              color: const Color(0xFFED1C24),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                widget.config.innerText.startLiveStreamingButton,
                style: TextStyle(
                  fontSize: 32.zR,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
  }

  Widget audioVideoViewForeground(
    BuildContext context,
    Size size,
    ZegoUIKitUser? user,
    Map<String, dynamic> extraInfo,
  ) {
    return Stack(
      children: [
        widget.config.audioVideoView.foregroundBuilder?.call(
              context,
              size,
              user,
              extraInfo,
            ) ??
            Container(color: Colors.transparent),
      ],
    );
  }

  Widget audioVideoViewBackground(
    BuildContext context,
    Size size,
    ZegoUIKitUser? user,
    Map<String, dynamic> extraInfo,
  ) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallView = (screenSize.width - size.width).abs() > 1;
    return Stack(
      children: [
        Container(
            color: isSmallView
                ? const Color(0xff333437)
                : const Color(0xff4A4B4D)),
        widget.config.audioVideoView.backgroundBuilder?.call(
              context,
              size,
              user,
              extraInfo,
            ) ??
            Container(color: Colors.transparent),
      ],
    );
  }

  zoomTopBar() {
    final ValueNotifier<bool> usePersonalIdNotifier = ValueNotifier<bool>(true);
    if (!widget.config.preview.topBar.isVisible) {
      return Container();
    }

    final buttonSize = Size(88.zR, 88.zR);
    final iconSize = Size(56.zR, 56.zR);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 4,
            top: 4,
            bottom: 4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<bool>(
                  valueListenable: ZegoUIKit()
                      .getCameraStateNotifier(ZegoUIKit().getLocalUser().id),
                  builder: (context, videoOn, child) {
                    return SwitchListTile(
                      title: const Text(
                        "Video on",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      value: videoOn,
                      onChanged: (v) {
                        print('camera state notifier is $videoOn');
                        _toggleCamera(v);
                      },
                      activeColor: Colors.white,
                      activeTrackColor: Colors.green,
                    );
                  }),
              Container(
                margin: const EdgeInsets.only(left: 20),
                width: double.infinity,
                color: Colors.grey,
                height: 1,
              ),
              ValueListenableBuilder<bool>(
                valueListenable: usePersonalIdNotifier,
                builder: (BuildContext context, bool value, Widget? child) {
                  return SwitchListTile(
                    title: const Text(
                      "Use personal meeting ID (PMI)",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      widget.liveID,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    value: value,
                    onChanged: (v) {
                      usePersonalIdNotifier.value = v;
                      print('use id notifier ${usePersonalIdNotifier.value}');
                    },
                    activeColor: Colors.white,
                    activeTrackColor: Colors.green,
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        zoomBottomBar()
      ],
    );
  }

  Widget zoomBottomBar() {
    if (!widget.config.preview.bottomBar.isVisible) {
      return Container();
    }
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(
          left: 89.zR,
          top: 0,
          right: 89.zR,
          bottom: 97.zR,
        ),
        child: zoomStartButton(),
      ),
    );
  }

  Widget zoomStartButton() {
    final permissions = <Permission>[];
    if (widget.config.turnOnCameraWhenJoining) {
      permissions.add(Permission.camera);
    }
    if (widget.config.turnOnMicrophoneWhenJoining) {
      permissions.add(Permission.microphone);
    }
    print('tapped');
    defaultAction() async {
      await checkPermissions(
        context: context,
        permissions: permissions,
        isShowDialog: true,
        translationText: widget.config.innerText,
        rootNavigator: widget.config.rootNavigator,
        popUpManager: widget.popUpManager,
        kickOutNotifier: widget.kickOutNotifier,
      ).then(
        (value) {
          if (!widget.liveStreamingPageReady.value) {
            ZegoLoggerService.logInfo(
              'live streaming page is waiting room login',
              tag: 'live-streaming',
              subTag: 'preview page',
            );
            return;
          }

          widget.startedNotifier.value = true;
        },
      );
    }

    return widget.config.preview.startLiveButtonBuilder?.call(context,
            () async {
          defaultAction.call();
        }) ??
        GestureDetector(
          onTap: defaultAction,
          child: Container(
            width: double.infinity,
            height: 94.zR,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.zR),
              color: Colors.blueAccent[700],
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Start a Meeting',
                style: TextStyle(
                  fontSize: 32.zR,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
  }

  void _toggleCamera(bool v) {
    final valueNotifier = v;

    final targetState = valueNotifier;

    if (targetState) {
      requestPermission(Permission.camera).then((value) {
        /// reverse current state
        ZegoUIKit().turnCameraOn(true);
      });
    } else {
      /// reverse current state
      ZegoUIKit().turnCameraOn(false);
    }

    ZegoUIKit().getCameraStateNotifier(ZegoUIKit().getLocalUser().id).value =
        !v;
  }
}
