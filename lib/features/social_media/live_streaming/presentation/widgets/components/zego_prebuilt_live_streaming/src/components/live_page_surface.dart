// Dart imports:
import 'dart:core';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/src/components/screen_util/core/size_extension.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/zoom/presentation/controller/stream_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/controller/stream_state.dart';

// Package imports:

// Project imports:
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/components/duration_time_board.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/components/message/view.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/core/live_status_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/core/plugins.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/core/live_duration_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/components/components.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/controller.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/core/connect_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/core/host_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/components/utils/pop_up_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/defines.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/config.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/events.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/events.defines.dart';
import 'package:fourtyninehub/res/style/const.dart';

import '../../../../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../../../../res/style/app_colors.dart';
import '../../../../../../../../../res/style/styles.dart';
import '../../../../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'dynamic_progress_indicator.dart';

/// @nodoc
class ZegoLiveStreamingLivePageSurface extends StatefulWidget {
  final bool isLiveStream;

  const ZegoLiveStreamingLivePageSurface({
    super.key,
    required this.config,
    required this.events,
    required this.defaultEndAction,
    required this.defaultLeaveConfirmationAction,
    required this.hostManager,
    required this.liveStatusManager,
    required this.liveDurationManager,
    required this.popUpManager,
    required this.connectManager,
    required this.isLiveStream,
    this.plugins,
  });

  final ZegoUIKitPrebuiltLiveStreamingConfig config;
  final ZegoUIKitPrebuiltLiveStreamingEvents events;
  final void Function(ZegoLiveStreamingEndEvent event) defaultEndAction;
  final Future<bool> Function(
    ZegoLiveStreamingLeaveConfirmationEvent event,
  ) defaultLeaveConfirmationAction;

  final ZegoLiveStreamingHostManager hostManager;
  final ZegoLiveStreamingStatusManager liveStatusManager;
  final ZegoLiveStreamingDurationManager liveDurationManager;
  final ZegoLiveStreamingPopUpManager popUpManager;
  final ZegoLiveStreamingPlugins? plugins;
  final ZegoLiveStreamingConnectManager connectManager;

  @override
  State<ZegoLiveStreamingLivePageSurface> createState() =>
      _ZegoLiveStreamingLivePageSurfaceState();
}

class _ZegoLiveStreamingLivePageSurfaceState
    extends State<ZegoLiveStreamingLivePageSurface>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.0, 0.0),
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: body,
    );
  }

  Widget get body {
    return BlocBuilder<StreamCubit, StreamState>(
      builder: (context, state) {
        return LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              durationTimeBoard(),
              if (!state.isOpenWhiteBoard) topBar(),
              if (widget.isLiveStream)
                Positioned.directional(
                  textDirection: context.textDirection,
                  end: 20,
                  start: context.screenWidth / 4,
                  top: 180.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      state.selectedGifts.isEmpty
                          ? Container(
                              width: context.screenWidth * 0.4,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Label(
                                            text: "Add ",
                                            style: Styles.headerText(),
                                          ),
                                          Image.asset(
                                            'assets/49-New-icons/goal.png',
                                            width: 70.w,
                                          ),
                                        ],
                                      ),
                                      const Sizer(),
                                      Label(
                                        text: "Live goals",
                                        style: Styles.headerText(),
                                      ),
                                    ]),
                              ))
                          : GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (_) {
                                      return Container(
                                          constraints: BoxConstraints(
                                            maxHeight: context.screenHeight / 2,
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                            color: Colors.grey,
                                            // borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    ImageFromInternet(
                                                      image: context
                                                              .read<UserCubit>()
                                                              .state
                                                              .data!
                                                              .profilePicture ??
                                                          UIConst
                                                              .imagePlaceHolder,
                                                      width: 130.w,
                                                      height: 130.h,
                                                      isCircle: true,
                                                    ),
                                                    SizedBox(width: 20.w),
                                                    Label(
                                                      text: context
                                                          .read<UserCubit>()
                                                          .state
                                                          .data!
                                                          .fullName,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white10,
                                                  ),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: List.generate(
                                                          state.selectedGifts
                                                              .length,
                                                          (index) => Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            15),
                                                                child: Row(
                                                                  children: [
                                                                    SvgPicture
                                                                        .network(
                                                                      state
                                                                          .selectedGifts[
                                                                              index]
                                                                          .picture!,
                                                                      height:
                                                                          100.h,
                                                                      width:
                                                                          100.w,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Label(
                                                                            text: context.isArabic
                                                                                ? state.selectedGifts[index].nameAr!
                                                                                : state.selectedGifts[index].nameEn!),
                                                                        RichText(
                                                                            text: TextSpan(
                                                                                text: '0',
                                                                                style: TextStyle(
                                                                                  color: Colors.yellow,
                                                                                  fontSize: 30.sp,
                                                                                ),
                                                                                children: [
                                                                              TextSpan(
                                                                                text: '/',
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontSize: 30.sp,
                                                                                ),
                                                                              ),
                                                                              TextSpan(
                                                                                text: state.selectedGifts[index].currentValue.toString(),
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontSize: 30.sp,
                                                                                ),
                                                                              ),
                                                                            ])),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ))),
                                                )
                                              ]));
                                    });
                              },
                              child: Container(
                                width: context.screenWidth * 0.4,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                            text: '0',
                                            style: TextStyle(
                                              color: Colors.yellow,
                                              fontSize: 30.sp,
                                            ),
                                            children: [
                                          TextSpan(
                                            text: '/',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30.sp,
                                            ),
                                          ),
                                          TextSpan(
                                            text: context
                                                .read<StreamCubit>()
                                                .state
                                                .selectedGifts[0]
                                                .currentValue
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30.sp,
                                            ),
                                          ),
                                        ])),
                                    // const Sizer(width: 30,),
                                    SvgPicture.network(
                                      state.selectedGifts[0].picture!,
                                      height: 75.h,
                                      width: 75.w,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      participants()
                    ],
                  ),
                ),
              bottomBar(),
              if (!state.isOpenWhiteBoard) messageList(),
              foreground(
                constraints.maxWidth,
                constraints.maxHeight,
              ),
            ],
          );
        });
      },
    );
  }

  Widget participants() => Container(
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(10)),
      child: ZoomParticipantsBuilder(widgetTop: widget));

  Widget topBar() {
    final isCoHostEnabled = (widget.plugins?.isEnabled ?? false) &&
        widget.config.bottomMenuBar.audienceButtons
            .contains(ZegoLiveStreamingMenuBarButtonName.coHostControlButton);
    return Positioned(
      left: 0,
      right: 0,
      top: 64.h,
      child: ZegoLiveStreamingTopBar(
        config: widget.config,
        events: widget.events,
        defaultEndAction: widget.defaultEndAction,
        defaultLeaveConfirmationAction: widget.defaultLeaveConfirmationAction,
        isCoHostEnabled: isCoHostEnabled,
        hostManager: widget.hostManager,
        hostUpdateEnabledNotifier: widget.hostManager.hostUpdateEnabledNotifier,
        connectManager: widget.connectManager,
        popUpManager: widget.popUpManager,
        isLeaveRequestingNotifier: ZegoUIKitPrebuiltLiveStreamingController()
            .isLeaveRequestingNotifier,
        translationText: widget.config.innerText,
        isLiveStream: widget.isLiveStream,
      ),
    );
  }

  Widget bottomBar() {
    final isCoHostEnabled = (widget.plugins?.isEnabled ?? false) &&
        widget.config.bottomMenuBar.audienceButtons
            .contains(ZegoLiveStreamingMenuBarButtonName.coHostControlButton);
    return Align(
      alignment: Alignment.bottomCenter,
      child: ZegoLiveStreamingBottomBar(
        buttonSize: zegoLiveButtonSize,
        config: widget.config,
        events: widget.events,
        defaultEndAction: widget.defaultEndAction,
        defaultLeaveConfirmationAction: widget.defaultLeaveConfirmationAction,
        hostManager: widget.hostManager,
        hostUpdateEnabledNotifier: widget.hostManager.hostUpdateEnabledNotifier,
        liveStatusNotifier: widget.liveStatusManager.notifier,
        connectManager: widget.connectManager,
        isLeaveRequestingNotifier: ZegoUIKitPrebuiltLiveStreamingController()
            .isLeaveRequestingNotifier,
        popUpManager: widget.popUpManager,
        isLiveStream: widget.isLiveStream,
        isCoHostEnabled: isCoHostEnabled,
        translationText: widget.config.innerText,
      ),
    );
  }

  Widget messageList() {
    if (!widget.config.inRoomMessage.visible) {
      return Container();
    }

    var listSize = Size(
      widget.config.inRoomMessage.width ?? 540.zR,
      widget.config.inRoomMessage.height ?? 400.zR,
    );
    if (listSize.width < 54.zR) {
      listSize = Size(54.zR, listSize.height);
    }
    if (listSize.height < 40.zR) {
      listSize = Size(listSize.width, 40.zR);
    }
    return Positioned(
      left: 32.zR + (widget.config.inRoomMessage.bottomLeft?.dx ?? 0),
      bottom: 124.zR + (widget.config.inRoomMessage.bottomLeft?.dy ?? 0),
      child: ConstrainedBox(
        constraints: BoxConstraints.loose(listSize),
        child: ZegoLiveStreamingInRoomLiveMessageView(
          config: widget.config.inRoomMessage,
          events: widget.events.inRoomMessage,
          innerText: widget.config.innerText,
          avatarBuilder: widget.config.avatarBuilder,
          pseudoStream: ZegoUIKitPrebuiltLiveStreamingController()
                  .message
                  .private
                  .streamControllerPseudoMessage
                  ?.stream ??
              const Stream.empty(),
        ),
      ),
    );
  }

  Widget durationTimeBoard() {
    if (!widget.config.duration.isVisible) {
      return Container();
    }

    return Positioned(
      left: 0,
      right: 0,
      top: 10,
      child: ZegoLiveStreamingDurationTimeBoard(
        config: widget.config.duration,
        events: widget.events.duration,
        manager: widget.liveDurationManager,
      ),
    );
  }

  Widget foreground(double width, double height) {
    return widget.config.foreground ?? Container();
  }
}
