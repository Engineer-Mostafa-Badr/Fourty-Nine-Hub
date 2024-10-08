// Dart imports:
import 'dart:core';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/animations/create_custom_transition.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/controller/tiktok_controller_extension.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/components/effects/beauty_effect_button.dart';

// Project imports:
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/components/utils/permissions.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/components/utils/pop_up_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/core/host_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/internal/defines.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

// Package imports:
import 'package:permission_handler/permission_handler.dart';

import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/zego_uikit.dart';

import '../../../../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../../../../core/messages/messages.dart';
import '../../../../../../../../../res/style/const.dart';
import '../../../../../../../../../res/style/styles.dart';
import '../../../../../../../../../service_locator/service_locator.dart';
import '../../../../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../../../../../zoom/presentation/controller/stream_cubit.dart';
import '../../../../../../../../zoom/presentation/controller/stream_state.dart';
import '../../../../../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../../../../tinder/presentation/cubit/gift_cubit.dart';
import '../../../../../../domain/entity/topic_entity.dart';
import '../config.dart';
import 'select_live_goals_screen.dart';

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

  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
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
                    layout: ZegoLayout.gallery(),
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
                  _liveInfo(constraints),
                  liveTopBar(),
                  liveBottomBar(),
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

  Positioned _liveInfo(BoxConstraints constraints) {
    return Positioned(
        top: 150.h,
        right: constraints.maxWidth / 8,
        left: constraints.maxWidth / 8,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: constraints.maxWidth / 1.3,
              padding: const EdgeInsets.all(15),
              // height: 50,
              color: Colors.grey.withOpacity(0.7),
              child: Row(
                children: [
                  ImageFromInternet(
                    image:
                        context.read<UserCubit>().state.data?.profilePicture ??
                            UIConst.profilePlaceHolder,
                    height: 100.h,
                    width: 100.w,
                    borderRadius: BorderRadius.circular(15),
                    isCircle: false,
                  ),
                  Expanded(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          textSelectionTheme: const TextSelectionThemeData(
                        selectionColor: AppColors.PRIMARY_COLOR,
                        cursorColor: AppColors.PRIMARY_COLOR,
                        selectionHandleColor: AppColors.PRIMARY_COLOR,
                      )),
                      child: TextFormField(
                        controller: _titleController,
                        selectionHeightStyle: BoxHeightStyle.tight,
                        selectionWidthStyle: BoxWidthStyle.tight,
                        selectionControls: materialTextSelectionControls,

                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        // validator: validateInput,
                        maxLength: 50,
                        style: Styles.mediumText(
                            color: Colors.white, decorationThickness: 0),
                        maxLines: null,
                        // onChanged: onTextChanged,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.edit),

                          // errorText: _errorMessage,
                          counterText: '',
                          labelStyle:
                              TextStyle(color: AppColors.QUANTITY_COLOR),
                          // hintStyle: TextStyle(color: AppColors.QUANTITY_COLOR),

                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: constraints.maxWidth / 20),
                    padding: const EdgeInsets.all(4),
                    width: constraints.maxWidth / 3,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.7),
                    ),
                    child: InkWell(
                      onTap: () {
                        _showTopicSheet(
                          context,
                          context.read<StreamCubit>().topics,
                        );
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/49-New-icons/hash.png',
                            width: 25,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          BlocBuilder<StreamCubit, StreamState>(
                            builder: (context, state) {
                              print(state.topicId);
                              print(state.topic);
                              return Text(
                                state.topic.isEmpty
                                    ? LocaleKeys.addTopic.localize
                                    : state.topic,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Sizer(),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // showGiftBottomSheet(context,
                      //     receiverId: '', forSelect: true);
                      Navigator.of(context).push(createCustomTransitionRoute(
                        MultiBlocProvider(providers: [
                          BlocProvider.value(
                              value: serviceLocator<StreamCubit>()),
                          BlocProvider(
                              create: (context) =>
                                  serviceLocator<GiftsCubit>()..fetchGifts()),
                        ], child: const SelectLiveGoalsScreen()),
                        TransitionType.bottomToTop,
                      ));
                    },
                    child: Container(
                      // margin: EdgeInsets.only(left: constraints.maxWidth / 20),
                      padding: const EdgeInsets.all(4),
                      width: constraints.maxWidth / 2,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.7),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/49-New-icons/goal.png',
                            width: 25,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            LocaleKeys.addLiveGoal.localize,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }

  Future<dynamic> _showTopicSheet(
      BuildContext context, List<TopicEntity> topics) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocProvider.value(
          value: serviceLocator<StreamCubit>(),
          child:
              BlocBuilder<StreamCubit, StreamState>(builder: (context, state) {
            return Column(mainAxisSize: MainAxisSize.min, children: [
              Label(
                text: LocaleKeys.selectATopic.localize,
                style: Styles.headerText(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...topics.map((topic) {
                return RadioListTile<String>(
                  title: Label(text: topic.name),
                  value: topic.name,
                  groupValue: state.topic.isEmpty ? null : state.topic,
                  onChanged: (value) {
                    context.read<StreamCubit>().setTopic(topic.name, topic.id);
                    Future.delayed(
                        const Duration(milliseconds: 100), () => context.pop());
                    // print('new topic is ${state.topic}');
                  },
                );
              }),
            ]);
          }),
        ),
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
          child: Label(
            text: LocaleKeys.cancel.localize,
            style: Styles.headerText(
                fontSize: 25, color: AppColors.SECONDARY_COLOR),
          ),
        ),
        title: Label(
          text: LocaleKeys.startAMeeting.localize,
          style: Styles.headerText(
              color:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
              fontSize: 35,
              fontWeight: FontWeight.bold),
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
              child: ZegoTextIconButton(
                onPressed: () {
                  Navigator.of(
                    context,
                    rootNavigator: widget.config.rootNavigator,
                  ).pop();
                },
                icon: ButtonIcon(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
                iconSize: iconSize,
                buttonSize: buttonSize,
              ),
            ),
            const Expanded(child: SizedBox()),
            Container(
              // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              margin: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.withOpacity(0.7),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // ZegoSwitchCameraButton(
                  //   buttonSize: buttonSize,
                  //   iconSize: iconSize,
                  //   icon: ButtonIcon(
                  //     icon: const Icon(Icons.switch_camera, size: 20),
                  //     backgroundColor: Colors.transparent,
                  //   ),
                  //   defaultUseFrontFacingCamera: ZegoUIKit()
                  //       .getUseFrontFacingCameraStateNotifier(
                  //           ZegoUIKit().getLocalUser().id)
                  //       .value,
                  // ),
                  ZegoToggleMicrophoneButton(
                    buttonSize: buttonSize,
                    iconSize: iconSize,
                    normalIcon: ButtonIcon(
                      icon: const Icon(
                        Icons.mic,
                        // size: 20,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    offIcon: ButtonIcon(
                      icon: const Icon(
                        Icons.mic_off_outlined,
                        // size: 20,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  ZegoToggleCameraButton(
                    buttonSize: buttonSize,
                    iconSize: iconSize,
                    normalIcon: ButtonIcon(
                        icon: const Icon(
                          Icons.videocam_outlined,
                          // size: 20,
                        ),
                        backgroundColor: Colors.transparent),
                    offIcon: ButtonIcon(
                      icon: const Icon(
                        Icons.videocam_off_outlined,
                        // size: 20,
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
                        // size: 20,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    iconStopSharing: ButtonIcon(
                      icon: const Icon(
                        Icons.stop_screen_share_outlined,
                        // size: 20,
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

  Widget liveBottomBar() {
    if (!widget.config.preview.bottomBar.isVisible) {
      return Container();
    }

    final buttonSize = Size(88.zR, 88.zR);
    final iconSize = Size(56.zR, 56.zR);

    final beautyButtonPlaceHolder =
        SizedBox(width: buttonSize.width, height: buttonSize.height);

    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(
            left: 89.zR,
            top: 0,
            right: 89.zR,
            bottom: 0.zR,
          ),
          child: Column(
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
              // beautyButtonPlaceHolder,
            ],
          ),
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

    defaultAction(String? title) async {
      await checkPermissions(
        context: context,
        permissions: permissions,
        isShowDialog: true,
        translationText: widget.config.innerText,
        rootNavigator: widget.config.rootNavigator,
        popUpManager: widget.popUpManager,
        kickOutNotifier: widget.kickOutNotifier,
      ).then(
        (value) async {
          if (!widget.liveStreamingPageReady.value) {
            ZegoLoggerService.logInfo(
              'live streaming page is waiting room login',
              tag: 'live-streaming',
              subTag: 'preview page',
            );
            return;
          }
          if (title != null && title.isNotEmpty) {
            await context.read<StreamCubit>().createLive(title: title);
            widget.startedNotifier.value = true;
          } else {
            showErrorMessage(context, 'Please enter simple title');
          }
          // context.read<StreamCubit>().createLive(title: title)
        },
      );
    }

    return widget.config.preview.startLiveButtonBuilder?.call(context,
            () async {
          defaultAction.call(_titleController.text.trim());
        }) ??
        GestureDetector(
          onTap: () {
            print(_titleController.text.trim());
            defaultAction(_titleController.text.trim());
          },
          child: Container(
            width: context.screenWidth / 1.5,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(44.zR),
              color: const Color(0xFFED1C24),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                LocaleKeys.goLive.localize,
                style: TextStyle(
                  fontSize: 32.zR,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
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

    // final buttonSize = Size(88.zR, 88.zR);
    // final iconSize = Size(56.zR, 56.zR);

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
                      title: Label(
                        text: LocaleKeys.videoOn.localize,
                        style: Styles.headerText(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      value: videoOn,
                      onChanged: (v) {
                        print('camera state notifier is $videoOn');
                        _toggleCamera(v);
                      },
                      activeColor: Colors.white,
                      activeTrackColor: AppColors.SECONDARY_COLOR,
                      inactiveTrackColor: AppColors.GREY_BORDER_COLOR,
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
                    title: Label(
                      text: "${LocaleKeys.usePersonalMeetingId.localize} (PMI)",
                      // maxLines: 3,
                      // overflow: TextOverflow.ellipsis,
                      style: Styles.headerText(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Label(
                      text: widget.liveID,
                      style: Styles.headerText(
                          color: Colors.grey,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    value: value,
                    onChanged: (v) {
                      usePersonalIdNotifier.value = v;
                      print('use id notifier ${usePersonalIdNotifier.value}');
                    },
                    activeColor: Colors.white,
                    activeTrackColor: AppColors.SECONDARY_COLOR,
                    inactiveTrackColor: AppColors.GREY_BORDER_COLOR,
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
        (value) async {
          if (!widget.liveStreamingPageReady.value) {
            ZegoLoggerService.logInfo(
              'live streaming page is waiting room login',
              tag: 'live-streaming',
              subTag: 'preview page',
            );
            return;
          }
          // await newMeeting(widget.liveID);

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
              color: AppColors.PRIMARY_COLOR,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                LocaleKeys.startAMeeting.localize,
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

final List<String> topics = ['Athletics', 'Sport', 'Cinema', 'Fun'];
