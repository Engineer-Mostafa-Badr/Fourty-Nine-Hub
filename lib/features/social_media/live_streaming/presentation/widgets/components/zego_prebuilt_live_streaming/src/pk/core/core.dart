// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/zego_uikit.dart';

// Package imports:

// Project imports:

import '../../config.dart';
import '../../core/host_manager.dart';
import '../../events.dart';
import '../../inner_text.dart';
import '../../internal/defines.dart';
import '../export.dart';
import 'data.dart';
import 'service/services.dart';

class ZegoUIKitPrebuiltLiveStreamingPK
    with ZegoUIKitPrebuiltLiveStreamingPKServices {
  ZegoUIKitPrebuiltLiveStreamingPK._internal();

  factory ZegoUIKitPrebuiltLiveStreamingPK() => instance;

  static final ZegoUIKitPrebuiltLiveStreamingPK instance =
      ZegoUIKitPrebuiltLiveStreamingPK._internal();

  bool _initialized = false;
  final _data = ZegoUIKitPrebuiltLiveStreamingPKData();

  String get currentRequestID => _data.currentRequestID;

  ValueNotifier<List<ZegoLiveStreamingPKUser>> get connectedPKHostsNotifier =>
      _data.currentPKUsers;

  ValueNotifier<ZegoLiveStreamingIncomingPKBattleRequestReceivedEvent?>
      get pkBattleRequestReceivedEventInMinimizingNotifier =>
          _data.pkBattleRequestReceivedEventInMinimizingNotifier;

  void init({
    required ZegoUIKitPrebuiltLiveStreamingConfig config,
    required ZegoUIKitPrebuiltLiveStreamingEvents events,
    required ZegoUIKitPrebuiltLiveStreamingInnerText innerText,
    required ZegoLiveStreamingHostManager hostManager,
    required ValueNotifier<LiveStatus> liveStatusNotifier,
    required ValueNotifier<bool> startedByLocalNotifier,
    required BuildContext Function()? contextQuery,
  }) {
    if (_initialized) {
      return;
    }

    ZegoLoggerService.logInfo(
      'init',
      tag: 'live-streaming-pk',
      subTag: 'service',
    );

    _initialized = true;

    _data.init(
      config: config,
      events: events,
      innerText: innerText,
      hostManager: hostManager,
      liveStatusNotifier: liveStatusNotifier,
      startedByLocalNotifier: startedByLocalNotifier,
      contextQuery: contextQuery,
    );

    initServices(coreData: _data);
  }

  Future<void> uninit() async {
    if (!_initialized) {
      return;
    }

    ZegoLoggerService.logInfo(
      'uninit',
      tag: 'live-streaming-pk',
      subTag: 'service',
    );

    _initialized = false;

    await cancelPKBattleRequest(
      targetHostIDs: ZegoUIKit()
          .getSignalingPlugin()
          .getAdvanceInvitees(
            _data.currentRequestID,
          )
          .map((e) => e.userID)
          .toList(),
    );
    await quitPKBattle(
      requestID: _data.currentRequestID,
    );

    _data.uninit();

    await uninitServices();
  }

  void updateContextQuery(BuildContext Function()? contextQuery) {
    ZegoLoggerService.logInfo(
      'update context query',
      tag: 'live-streaming-pk',
      subTag: 'service',
    );

    _data.contextQuery = contextQuery;
  }
}
