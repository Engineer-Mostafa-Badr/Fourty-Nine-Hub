// Dart imports:
import 'dart:core';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/zoom_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/zoom_state.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/duration_time_board.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/message/view.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/core/live_status_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/core/plugins.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/core/live_duration_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/components.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/controller.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/core/connect_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/core/host_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/utils/pop_up_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/defines.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/config.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/events.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/events.defines.dart';

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
    return BlocBuilder<MeetingCubit, MeetingState>(
      builder: (context, state) {
        return LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              durationTimeBoard(),
              if (!state.isOpenWhiteBoard) topBar(),
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

  Widget topBar() {
    final isCoHostEnabled = (widget.plugins?.isEnabled ?? false) &&
        widget.config.bottomMenuBar.audienceButtons
            .contains(ZegoLiveStreamingMenuBarButtonName.coHostControlButton);
    return Positioned(
      left: 0,
      right: 0,
      top: 64.zR,
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
