import 'package:wakelock_plus/wakelock_plus.dart';

class ScreenWakeLockManager {
  // Enable wakelock to keep screen on
  static Future<void> keepScreenOn() async {
    // This prevents screen from turning off
    await WakelockPlus.enable();
  }

  // Disable wakelock to allow screen to turn off
  static Future<void> allowScreenOff() async {
    await WakelockPlus.disable();
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