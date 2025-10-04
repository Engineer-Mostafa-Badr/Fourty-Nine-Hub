import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter/services.dart';

class ScreenWakeLockManager {
  // Enable wakelock to keep screen on
  static Future<void> keepScreenOn() async {
    try {
      // This prevents screen from turning off
      await WakelockPlus.enable();
    } on PlatformException catch (e) {
      // Handle NoActivityException gracefully
      if (e.code == 'NoActivityException') {
        // Activity not ready yet, ignore silently
        return;
      }
      // Re-throw other platform exceptions
      rethrow;
    }
  }

  // Disable wakelock to allow screen to turn off
  static Future<void> allowScreenOff() async {
    try {
      await WakelockPlus.disable();
    } on PlatformException catch (e) {
      // Handle NoActivityException gracefully
      if (e.code == 'NoActivityException') {
        // Activity not ready yet, ignore silently
        return;
      }
      // Re-throw other platform exceptions
      rethrow;
    }
  }

  // Toggle wakelock state
  static Future<void> toggleWakelock(bool enable) async {
    if (enable) {
      await keepScreenOn();
    } else {
      await allowScreenOff();
    }
  }

  // Get current wakelock state
  static Future<bool> isScreenKeptOn() async {
    return await WakelockPlus.enabled;
  }
}