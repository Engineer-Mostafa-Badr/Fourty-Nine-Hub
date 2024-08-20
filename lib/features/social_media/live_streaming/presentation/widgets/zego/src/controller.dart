// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'events.dart';
import 'live_streaming.dart';

import 'controller/audio_video.dart';

import 'controller/co.host.dart';

import 'controller/message.dart';

import 'controller/minimize.dart';

import 'controller/room.dart';

import 'controller/user.dart';

import 'controller/screen.dart';

import 'controller/pk.dart';

import 'controller/swiping.dart';

import 'controller/private/private.dart';

/// Used to control the live streaming functionality.
///
/// [ZegoUIKitPrebuiltLiveStreamingController] is a **singleton instance** class,
/// you can directly invoke it by ZegoUIKitPrebuiltLiveStreamingController().
///
/// If the default live streaming UI and interactions do not meet your requirements, you can use this [ZegoUIKitPrebuiltLiveStreamingController] to actively control the business logic.
/// This class is used by setting the [ZegoUIKitPrebuiltLiveStreaming.controller] parameter in the constructor of [ZegoUIKitPrebuiltLiveStreaming].
class ZegoUIKitPrebuiltLiveStreamingController
    with
        ZegoLiveStreamingControllerPrivate,
        ZegoLiveStreamingControllerMessage,
        ZegoLiveStreamingControllerMinimizing,
        ZegoLiveStreamingControllerRoom,
        ZegoLiveStreamingControllerUser,
        ZegoLiveStreamingControllerScreen,
        ZegoLiveStreamingControllerCoHost,
        ZegoLiveStreamingControllerPK,
        ZegoLiveStreamingControllerSwiping,
        ZegoLiveStreamingControllerAudioVideo {
  factory ZegoUIKitPrebuiltLiveStreamingController() => instance;

  /// This function is used to end the Live Streaming.
  ///
  /// You can pass the context [context] for any necessary pop-ups or page transitions.
  /// By using the [showConfirmation] parameter, you can control whether to display a confirmation dialog to confirm ending the Live Streaming.
  ///
  /// This function behaves the same as the close button in the calling interface's top right corner, and it is also affected by the [ZegoUIKitPrebuiltLiveStreamingEvents.onLeaveConfirmation], [ZegoUIKitPrebuiltLiveStreamingEvents.onEnded] settings in the config.
  Future<bool> leave(
    BuildContext context, {
    bool showConfirmation = false,
  }) async {
    final result =
        await room.leave(context, showConfirmation: showConfirmation);
    if (result) {
      private.uninitByPrebuilt();
      pk.private.uninitByPrebuilt();
      room.private.uninitByPrebuilt();
      user.private.uninitByPrebuilt();
      message.private.uninitByPrebuilt();
      coHost.private.uninitByPrebuilt();
      audioVideo.private.uninitByPrebuilt();
      minimize.private.uninitByPrebuilt();
      swiping.private.uninitByPrebuilt();
    }

    return result;
  }

  ValueNotifier<bool> get isLeaveRequestingNotifier =>
      room.private.isLeaveRequestingNotifier;

  ZegoUIKitPrebuiltLiveStreamingController._internal() {
    ZegoLoggerService.logInfo(
      'ZegoUIKitPrebuiltLiveStreamingController create',
      tag: 'live-streaming',
      subTag: 'controller',
    );
  }

  static final ZegoUIKitPrebuiltLiveStreamingController instance =
      ZegoUIKitPrebuiltLiveStreamingController._internal();
}
