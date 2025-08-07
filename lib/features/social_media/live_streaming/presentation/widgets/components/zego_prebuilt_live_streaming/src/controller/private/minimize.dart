import '../../../../zego_uikit/zego_uikit.dart';
import '../../core/connect_manager.dart';
import '../../core/core_managers.dart';
import '../../internal/defines.dart';
import '../../minimizing/data.dart';

/// @nodoc
mixin ZegoLiveStreamingControllerMinimizingPrivate {
  final _private = ZegoLiveStreamingControllerMinimizingPrivateImpl();

  /// Don't call that
  ZegoLiveStreamingControllerMinimizingPrivateImpl get private => _private;
}

/// @nodoc
/// Here are the APIs related to invitation.
class ZegoLiveStreamingControllerMinimizingPrivateImpl {
  ZegoLiveStreamingMinimizeData? get minimizeData => _minimizeData;

  ZegoLiveStreamingMinimizeData? _minimizeData;

  ZegoLiveStreamingConnectManager? get _connectManager =>
      ZegoLiveStreamingManagers().connectManager;

  bool get isLiving =>
      _connectManager?.liveStatusNotifier.value == LiveStatus.living;

  /// Please do not call this interface. It is the internal logic of Prebuilt.
  void initByPrebuilt({
    required ZegoLiveStreamingMinimizeData minimizeData,
  }) {
    ZegoLoggerService.logInfo(
      'init by prebuilt',
      tag: 'call',
      subTag: 'controller.minimize.p',
    );

    _minimizeData = minimizeData;
  }

  /// Please do not call this interface. It is the internal logic of Prebuilt.
  void uninitByPrebuilt() {
    ZegoLoggerService.logInfo(
      'un-init by prebuilt',
      tag: 'call',
      subTag: 'controller.minimize.p',
    );

    _minimizeData = null;
  }
}
