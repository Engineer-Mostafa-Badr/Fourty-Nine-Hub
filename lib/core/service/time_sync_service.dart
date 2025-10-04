import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:ntp/ntp.dart';

/// Monitors device time drift against NTP and exposes a listenable flag.
class TimeSyncService {
  TimeSyncService({
    Duration? checkInterval,
    Duration? allowedDrift,
  })  : _checkInterval = checkInterval ?? const Duration(minutes: 5),
        _allowedDrift = allowedDrift ?? const Duration(minutes: 2);

  final Duration _checkInterval;
  final Duration _allowedDrift;

  final ValueNotifier<bool> isTimeIncorrect = ValueNotifier<bool>(false);

  Timer? _timer;
  bool _isChecking = false;

  Future<void> start() async {
    await _checkOnce();
    _timer?.cancel();
    _timer = Timer.periodic(_checkInterval, (_) => _checkOnce());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _checkOnce() async {
    if (_isChecking) return;
    _isChecking = true;
    try {
      // Query network time. If it fails, keep previous state.
      final networkNow = await NTP.now();
      final deviceNow = DateTime.now();
      final difference = networkNow.difference(deviceNow).abs();
      final incorrect = difference > _allowedDrift;
      if (incorrect != isTimeIncorrect.value) {
        isTimeIncorrect.value = incorrect;
      }
    } catch (_) {
      // Ignore errors; do not flip state on failure.
    } finally {
      _isChecking = false;
    }
  }

  /// Force an immediate time check.
  Future<void> checkNow() => _checkOnce();
}


