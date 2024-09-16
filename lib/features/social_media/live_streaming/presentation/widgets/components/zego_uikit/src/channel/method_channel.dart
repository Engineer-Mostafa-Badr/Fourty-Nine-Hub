// Dart imports:
import 'dart:io' show Platform;

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../services/uikit_service.dart';
import 'platform_interface.dart';

// Project imports:

/// @nodoc
/// An implementation of [ZegoUIKitPluginPlatform] that uses method channels.
class MethodChannelZegoUIKitPlugin extends ZegoUIKitPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('zego_uikit_plugin');

  /// backToDesktop
  @override
  Future<void> backToDesktop({
    bool nonRoot = false,
  }) async {
    if (Platform.isIOS) {
      ZegoLoggerService.logInfo(
        'not support in iOS',
        tag: 'uikit-channel',
        subTag: 'backToDesktop',
      );
      return;
    }

    ZegoLoggerService.logInfo(
      'nonRoot:$nonRoot',
      tag: 'uikit-channel',
      subTag: 'backToDesktop',
    );

    try {
      await methodChannel.invokeMethod<String>('backToDesktop', {
        'nonRoot': nonRoot,
      });
    } on PlatformException catch (e) {
      ZegoLoggerService.logError(
        'Failed to back to desktop: $e.',
        tag: 'uikit-channel',
        subTag: 'backToDesktop',
      );
    }
  }

  @override
  Future<bool> isLockScreen() async {
    if (Platform.isIOS) {
      ZegoLoggerService.logInfo(
        'not support in iOS',
        tag: 'uikit-channel',
        subTag: 'isLockScreen',
      );
      return false;
    }

    var isLock = false;
    try {
      isLock = await methodChannel.invokeMethod<bool?>('isLockScreen') ?? false;
    } on PlatformException catch (e) {
      ZegoLoggerService.logError(
        'Failed to check isLock: $e.',
        tag: 'uikit-channel',
        subTag: 'isLockScreen',
      );
    }

    return isLock;
  }
}
