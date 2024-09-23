// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

// Project imports:
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/core/live_duration_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/config.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/events.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/zego_uikit.dart';

import '../../../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../../../res/style/app_colors.dart';
import '../../../../../../../../../res/style/styles.dart';

/// @nodoc
class ZegoLiveStreamingDurationTimeBoard extends StatefulWidget {
  final ZegoLiveStreamingDurationConfig config;
  final ZegoLiveStreamingDurationEvents events;
  final ZegoLiveStreamingDurationManager manager;

  final double? fontSize;

  const ZegoLiveStreamingDurationTimeBoard({
    super.key,
    required this.config,
    required this.events,
    required this.manager,
    this.fontSize,
  });

  @override
  State<StatefulWidget> createState() =>
      _ZegoLiveStreamingDurationTimeBoardState();
}

class _ZegoLiveStreamingDurationTimeBoardState
    extends State<ZegoLiveStreamingDurationTimeBoard> {
  Timer? durationTimer;
  Duration? beginDuration;
  var durationNotifier = ValueNotifier<Duration>(Duration.zero);

  @override
  void initState() {
    super.initState();

    if (widget.config.isVisible) {
      ZegoLoggerService.logInfo(
        'init duration',
        tag: 'live-streaming',
        subTag: 'prebuilt',
      );

      if (widget.manager.isValid) {
        startDurationTimerByNetworkTime();
      } else {
        ZegoLoggerService.logInfo(
          'manager notifier value is null, wait...',
          tag: 'live-streaming',
          subTag: 'duration time board',
        );

        widget.manager.notifier.addListener(startDurationTimerByNetworkTime);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();

    durationTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.config.isVisible) {
      return Container();
    }

    return ValueListenableBuilder<Duration>(
      valueListenable: durationNotifier,
      builder: (context, elapsedTime, _) {
        if (!widget.manager.isValid) {
          return Container();
        }

        return elapsedTime.inSeconds <= 0
            ? Container()
            : Label(
                text:durationFormatString(elapsedTime),
                textAlign: TextAlign.center,
                style: Styles.mediumText(color: AppColors.SECONDARY_COLOR)
              );
      },
    );
  }

  String durationFormatString(Duration elapsedTime) {
    final hours = elapsedTime.inHours;
    final minutes = elapsedTime.inMinutes.remainder(60);
    final seconds = elapsedTime.inSeconds.remainder(60);

    final minutesFormatString =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    return hours > 0
        ? '${hours.toString().padLeft(2, '0')}:$minutesFormatString'
        : minutesFormatString;
  }

  void startDurationTimerByNetworkTime() {
    if (widget.manager.isValid) {
      final networkTimeNow = ZegoUIKit().getNetworkTime();
      if (null == networkTimeNow.value) {
        ZegoLoggerService.logInfo(
          'network time is null, wait...',
          tag: 'live-streaming',
          subTag: 'duration time board',
        );

        ZegoUIKit()
            .getNetworkTime()
            .addListener(waitNetworkTimeUpdateForStartDurationTimer);
      } else {
        startDurationTimer(networkTimeNow.value!);
      }
    }
  }

  void waitNetworkTimeUpdateForStartDurationTimer() {
    ZegoUIKit()
        .getNetworkTime()
        .removeListener(waitNetworkTimeUpdateForStartDurationTimer);

    final networkTimeNow = ZegoUIKit().getNetworkTime();
    ZegoLoggerService.logInfo(
      'network time update:$networkTimeNow',
      tag: 'live-streaming',
      subTag: 'duration time board',
    );

    startDurationTimer(networkTimeNow.value!);
  }

  void startDurationTimer(DateTime networkTimeNow) {
    ZegoLoggerService.logInfo(
      'start duration timer, network time is $networkTimeNow, live begin time is ${widget.manager.notifier.value}',
      tag: 'live-streaming',
      subTag: 'duration time board',
    );

    beginDuration = networkTimeNow.difference(widget.manager.notifier.value);

    durationTimer?.cancel();
    durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      durationNotifier.value = beginDuration! + Duration(seconds: timer.tick);
      widget.events.onUpdated?.call(durationNotifier.value);
    });
  }
}
