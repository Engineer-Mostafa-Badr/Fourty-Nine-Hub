// Dart imports:
import 'dart:async';

// Package imports:
import 'package:statemachine/statemachine.dart' as sm;

import '../../../zego_uikit/src/services/uikit_service.dart';
import '../controller.dart';
import '../core/core_managers.dart';
import '../events.defines.dart';
import 'defines.dart';

// Project imports:

/// @nodoc
typedef ZegoLiveStreamingMiniOverlayMachineStateChanged = void Function(
  ZegoLiveStreamingMiniOverlayPageState,
);

/// @nodoc
class ZegoLiveStreamingMiniOverlayMachine {
  factory ZegoLiveStreamingMiniOverlayMachine() => _instance;

  sm.Machine<ZegoLiveStreamingMiniOverlayPageState> get machine => _machine;

  bool get isMinimizing =>
      ZegoLiveStreamingMiniOverlayPageState.minimizing == state;

  ZegoLiveStreamingMiniOverlayPageState get state =>
      _machine.current?.identifier ??
      ZegoLiveStreamingMiniOverlayPageState.idle;

  void registerStateChanged(
    ZegoLiveStreamingMiniOverlayMachineStateChanged listener,
  ) {
    _onStateChangedListeners.add(listener);

    ZegoLoggerService.logInfo(
      'add listener:$listener, size:${_onStateChangedListeners.length}',
      tag: 'live-streaming',
      subTag: 'overlay machine',
    );
  }

  void unregisterStateChanged(
    ZegoLiveStreamingMiniOverlayMachineStateChanged listener,
  ) {
    _onStateChangedListeners.remove(listener);

    ZegoLoggerService.logInfo(
      'remove listener:$listener, size:${_onStateChangedListeners.length}',
      tag: 'live-streaming',
      subTag: 'overlay machine',
    );
  }

  void changeState(
    ZegoLiveStreamingMiniOverlayPageState state,
  ) {
    ZegoLoggerService.logInfo(
      'change state outside to $state',
      tag: 'live-streaming',
      subTag: 'overlay machine',
    );

    switch (state) {
      case ZegoLiveStreamingMiniOverlayPageState.idle:
        _kickOutSubscription?.cancel();

        _stateIdle.enter();
        break;
      case ZegoLiveStreamingMiniOverlayPageState.living:
        _kickOutSubscription?.cancel();

        _stateLiving.enter();
        break;
      case ZegoLiveStreamingMiniOverlayPageState.minimizing:
        _kickOutSubscription = ZegoUIKit()
            .getMeRemovedFromRoomStream()
            .listen(_onMeRemovedFromRoom);

        _stateMinimizing.enter();
        break;
    }
  }

  void _init() {
    ZegoLoggerService.logInfo(
      'init',
      tag: 'live-streaming',
      subTag: 'overlay machine',
    );

    _machine.onAfterTransition.listen((event) {
      ZegoLoggerService.logInfo(
        'mini overlay, from ${event.source} to ${event.target}',
        tag: 'live-streaming',
        subTag: 'overlay machine',
      );

      for (final listener in _onStateChangedListeners) {
        listener.call(_machine.current!.identifier);
      }
    });

    _stateIdle = _machine.newState(
        ZegoLiveStreamingMiniOverlayPageState.idle); //  default state;
    _stateLiving =
        _machine.newState(ZegoLiveStreamingMiniOverlayPageState.living);
    _stateMinimizing =
        _machine.newState(ZegoLiveStreamingMiniOverlayPageState.minimizing);
  }

  Future<void> _onMeRemovedFromRoom(String fromUserID) async {
    ZegoLoggerService.logInfo(
      'local user removed by $fromUserID',
      tag: 'live-streaming',
      subTag: 'mini overlay page',
    );
    changeState(ZegoLiveStreamingMiniOverlayPageState.idle);

    ZegoLiveStreamingManagers().uninitPluginAndManagers();

    await ZegoUIKit().resetSoundEffect();
    await ZegoUIKit().resetBeautyEffect();
    // await ZegoUIKit().leaveRoom(); //  kick-out will leave in zego_uikit

    ZegoUIKitPrebuiltLiveStreamingController()
        .minimize
        .private
        .minimizeData
        ?.events
        .onEnded
        ?.call(
            ZegoLiveStreamingEndEvent(
              reason: ZegoLiveStreamingEndReason.kickOut,
              isFromMinimizing: true,
              kickerUserID: fromUserID,
            ), () {
      /// now is minimizing state, not need to navigate, just switch to idle
      ZegoUIKitPrebuiltLiveStreamingController().minimize.hide();
    });

    _uninitControllerByPrebuilt();
  }

  void _uninitControllerByPrebuilt() {
    ZegoUIKitPrebuiltLiveStreamingController().private.uninitByPrebuilt();
    ZegoUIKitPrebuiltLiveStreamingController().pk.private.uninitByPrebuilt();
    ZegoUIKitPrebuiltLiveStreamingController().room.private.uninitByPrebuilt();
    ZegoUIKitPrebuiltLiveStreamingController().user.private.uninitByPrebuilt();
    ZegoUIKitPrebuiltLiveStreamingController()
        .message
        .private
        .uninitByPrebuilt();
    ZegoUIKitPrebuiltLiveStreamingController()
        .coHost
        .private
        .uninitByPrebuilt();
    ZegoUIKitPrebuiltLiveStreamingController()
        .audioVideo
        .private
        .uninitByPrebuilt();
    ZegoUIKitPrebuiltLiveStreamingController()
        .minimize
        .private
        .uninitByPrebuilt();
    ZegoUIKitPrebuiltLiveStreamingController()
        .swiping
        .private
        .uninitByPrebuilt();
  }

  /// private variables

  ZegoLiveStreamingMiniOverlayMachine._internal() {
    _init();
  }

  static final ZegoLiveStreamingMiniOverlayMachine _instance =
      ZegoLiveStreamingMiniOverlayMachine._internal();

  final _machine = sm.Machine<ZegoLiveStreamingMiniOverlayPageState>();
  final List<ZegoLiveStreamingMiniOverlayMachineStateChanged>
      _onStateChangedListeners = [];

  late sm.State<ZegoLiveStreamingMiniOverlayPageState> _stateIdle;
  late sm.State<ZegoLiveStreamingMiniOverlayPageState> _stateLiving;
  late sm.State<ZegoLiveStreamingMiniOverlayPageState> _stateMinimizing;

  StreamSubscription<dynamic>? _kickOutSubscription;
}
