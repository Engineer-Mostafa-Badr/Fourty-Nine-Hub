import 'dart:developer';

import 'package:fourtyninehub/core/service/storage.dart';
import 'package:vibration/vibration.dart';

class ManageVibration {
  static Future<void> vibrate() async {
    log("vibrate");
    bool enableVibration = await Storage.getVibrationValue();
    if(enableVibration){
      log("enableVibration");
      Vibration.hasVibrator().then((hasVibrator) {
        log("hasVibrator $hasVibrator");
        if (hasVibrator ?? false) {
          log("hasVibrator");
          Vibration.vibrate(duration: 100); // vibration for 100ms
        }
      });
    }
  }
}