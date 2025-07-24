import 'package:fourtyninehub/core/service/storage.dart';
import 'package:vibration/vibration.dart';

class ManageVibration {
  static Future<void> vibrate() async {
    bool enableVibration = await Storage.getVibrationValue();
    if(enableVibration){
      Vibration.hasVibrator().then((hasVibrator) {
        if (hasVibrator ?? false) {
          Vibration.vibrate(duration: 100); // vibration for 100ms
        }
      });
    }
  }
}