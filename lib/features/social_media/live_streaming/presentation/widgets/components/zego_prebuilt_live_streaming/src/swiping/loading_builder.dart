// Flutter imports:
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

// Package imports:

import '../../../zego_uikit/src/services/uikit_service.dart';
import '../minimizing/defines.dart';
import '../minimizing/overlay_machine.dart';
import 'logout_notifier.dart';

// Project imports:

/// @nodoc
class ZegoLiveStreamingSwipingRoomLoadingBuilder extends StatefulWidget {
  const ZegoLiveStreamingSwipingRoomLoadingBuilder({
    super.key,
    required this.targetRoomID,
    required this.roomBuilder,
    required this.loadingBuilder,
  });

  final String targetRoomID;
  final Widget Function() roomBuilder;
  final Widget Function(String roomID)? loadingBuilder;

  @override
  State<ZegoLiveStreamingSwipingRoomLoadingBuilder> createState() =>
      _ZegoUIKitPrebuiltLiveStreamingScrollerElementState();
}

/// @nodoc
class _ZegoUIKitPrebuiltLiveStreamingScrollerElementState
    extends State<ZegoLiveStreamingSwipingRoomLoadingBuilder> {
  final roomBuildNotifier = ValueNotifier<bool>(false);
  final roomLogoutNotifier = ZegoLiveStreamingSwipingRoomLogoutNotifier();

  @override
  void initState() {
    super.initState();

    final isFromMinimizing = ZegoLiveStreamingMiniOverlayPageState.idle !=
        ZegoLiveStreamingMiniOverlayMachine().state;

    ///wait express room and zim room logout
    if (isFromMinimizing || roomLogoutNotifier.value) {
      ZegoLoggerService.logInfo(
        'room ${roomLogoutNotifier.checkingRoomID} is logout or from minimizing($isFromMinimizing), can build',
        tag: 'live-streaming',
        subTag: 'swiping-loading',
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        roomBuildNotifier.value = true;
      });
    } else {
      ZegoLoggerService.logInfo(
        'room ${roomLogoutNotifier.checkingRoomID} is not logout, wait room logout',
        tag: 'live-streaming',
        subTag: 'swiping-loading',
      );

      roomLogoutNotifier.notifier.addListener(onRoomStateChanged);
    }
  }

  @override
  void dispose() {
    super.dispose();
    roomLogoutNotifier.notifier.removeListener(onRoomStateChanged);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: roomBuildNotifier,
      builder: (context, canBuild, _) {
        return canBuild
            ? widget.roomBuilder()
            : Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: widget.loadingBuilder?.call(widget.targetRoomID) ??
                      const CustomCircularProgressIndicator(),
                ),
              );
      },
    );
  }

  void onRoomStateChanged() {
    ZegoLoggerService.logInfo(
      'room ${roomLogoutNotifier.checkingRoomID} state changed, logout:${roomLogoutNotifier.value}',
      tag: 'live-streaming',
      subTag: 'swiping-loading',
    );

    if (roomLogoutNotifier.value) {
      ZegoLoggerService.logInfo(
        'room ${roomLogoutNotifier.checkingRoomID} had logout, build..',
        tag: 'live-streaming',
        subTag: 'swiping-loading',
      );

      roomBuildNotifier.value = true;
    }
  }
}
